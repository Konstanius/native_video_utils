package me.konstanius.native_video_utils;

import android.annotation.TargetApi;
import android.media.*;
import android.os.Build;

import java.io.*;
import java.nio.ByteBuffer;
import java.util.HashMap;

public class VideoUtils {
    private static final String LOGTAG = "VideoUtils";
    private static final int DEFAULT_BUFFER_SIZE = 1 * 1024 * 1024;


    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    public static String genVideoUsingMuxer(String srcPath, String dstPath, int startMs, int endMs, boolean useAudio, boolean useVideo) {
        if (startMs > 0 && endMs > 0 && startMs >= endMs) {
            return "trim_start_after_end";
        }
        if (new File(dstPath).exists()) {
            return "target_file_exists";
        }

        MediaExtractor extractor = new MediaExtractor();
        FileDescriptor fd;
        MediaMuxer muxer;
        try {
            fd = new FileInputStream(srcPath).getFD();
        } catch (IOException e) {
            return "source_file_not_found";
        }

        try {
            extractor.setDataSource(fd);
        } catch (IOException e) {
            return "source_corrupt";
        }

        try {
            muxer = new MediaMuxer(dstPath, MediaMuxer.OutputFormat.MUXER_OUTPUT_MPEG_4);
        } catch (IOException e) {
            return "target_file_access";
        }

        MediaMetadataRetriever retrieverSrc = new MediaMetadataRetriever();
        retrieverSrc.setDataSource(srcPath);
        if (startMs > 0 || endMs > 0) {
            String durationString = retrieverSrc.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION);
            if (durationString != null) {
                int duration = Integer.parseInt(durationString);
                if (startMs > duration) {
                    return "trim_start_too_late";
                }
                if (endMs > duration) {
                    endMs = duration;
                }
            }
        } else {
            startMs = 0;
            endMs = 0;
        }

        int trackCount = extractor.getTrackCount();

        HashMap<Integer, Integer> indexMap = new HashMap<>(trackCount);
        int bufferSize = -1;
        for (int i = 0; i < trackCount; i++) {
            MediaFormat format = extractor.getTrackFormat(i);

            String mime = format.getString(MediaFormat.KEY_MIME);
            boolean selectCurrentTrack = false;
            if (mime.startsWith("audio/") && useAudio) {
                selectCurrentTrack = true;
            } else if (mime.startsWith("video/") && useVideo) {
                selectCurrentTrack = true;
            }
            if (selectCurrentTrack) {
                extractor.selectTrack(i);
                int dstIndex = muxer.addTrack(format);
                indexMap.put(i, dstIndex);
                if (format.containsKey(MediaFormat.KEY_MAX_INPUT_SIZE)) {
                    int newSize = format.getInteger(MediaFormat.KEY_MAX_INPUT_SIZE);
                    bufferSize = newSize > bufferSize ? newSize : bufferSize;
                }
            }
        }
        if (bufferSize < 0) {
            bufferSize = DEFAULT_BUFFER_SIZE;
        }

        String degreesString = retrieverSrc.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION);
        if (degreesString != null) {
            int degrees = Integer.parseInt(degreesString);
            if (degrees >= 0) {
                muxer.setOrientationHint(degrees);
            }
        }
        if (startMs > 0) {
            extractor.seekTo(startMs * 1000, MediaExtractor.SEEK_TO_CLOSEST_SYNC);
        }

        int offset = 0;
        int trackIndex = -1;
        ByteBuffer dstBuf = ByteBuffer.allocate(bufferSize);
        MediaCodec.BufferInfo bufferInfo = new MediaCodec.BufferInfo();
        try {
            muxer.start();
            while (true) {
                bufferInfo.offset = offset;
                bufferInfo.size = extractor.readSampleData(dstBuf, offset);
                if (bufferInfo.size < 0) {
                    bufferInfo.size = 0;
                    break;
                } else {
                    bufferInfo.presentationTimeUs = extractor.getSampleTime();
                    if (endMs > 0 && bufferInfo.presentationTimeUs > (endMs * 1000)) {
                        break;
                    } else {
                        bufferInfo.flags = extractor.getSampleFlags();
                        trackIndex = extractor.getSampleTrackIndex();
                        muxer.writeSampleData(indexMap.get(trackIndex), dstBuf, bufferInfo);
                        extractor.advance();
                    }
                }
            }
            muxer.stop();
        } finally {
            muxer.release();
        }

        return "";
    }
}
