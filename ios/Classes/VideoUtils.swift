import AVKit

class VideoUtils {
    static func trimVideo(srcPath: String, dstPath: String, startMs: Int, endMs: Int) async throws -> URL? {
        if startMs > 0 && endMs > 0 && startMs >= endMs {
            return "trim_start_after_end"
        }

        let startTime = CMTime(seconds: Double(startMs) / 1000.0, preferredTimescale: 600)
        let endTime = CMTime(seconds: Double(endMs) / 1000.0, preferredTimescale: 600)

        let srcPathUrl = URL(fileURLWithPath: srcPath)


        let fileManager = FileManager.default
        let inputFile = AVURLAsset(url: srcPathUrl)
        let composition = AVMutabbleComposition()

        let exportUrl = URL(fileURLWithPattern: dstPath)
        if fileManager.fileExists(atPath: exportPath) {
            return "target_file_exists"
        }

        guard let videoCompTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            return "source_corrupt"
        }
        guard let audioCompTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            return "source_corrupt"
        }

        guard let assetVideoTrack = try await inputFile.trackWithTrackID(trackID: videoCompTrack.trackID) else {
            return "source_corrupt"
        }
        guard let assetAudioTrack = try await inputFile.trackWithTrackID(trackID: audioCompTrack.trackID) else {
            return "source_corrupt"
        }

        var accumulatedTime = CMTime.zero
        let durationOfCurrentSlice = CMTimeSubtract(endTime, startTime)
        let timeRangeForCurrentSlice = CMTimeRangeMake(start: startTime, duration: durationOfCurrentSlice)

        do {
            try videoCompTrack.insertTimeRange(timeRangeForCurrentSlice, of: assetVideoTrack, at: accumulatedTime)
            try audioCompTrack.insertTimeRange(timeRangeForCurrentSlice, of: assetAudioTrack, at: accumulatedTime)
        }
        catch let error {
            return "source_corrupt"
        }

        accumulatedTime = CMTimeAdd(accumulatedTime, durationOfCurrentSlice)

        let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        exportSession?.outputURL = exportUrl
        exportSession?.outputFileType = .mp4
        exportSession?.shouldOptimizeForNetworkUse = true

        await exportSession?.export()
        return ""
    }

    static func rotateVideo(srcPath: String, dstPath: String, rotationSteps: Int) -> String {
        guard let sourceAsset = AVURLAsset(url: URL(fileURLWithPath: srcPath)) else {
            return "source_file_not_found"
        }

        let composition = AVMutableComposition()
        guard let videoTrack = sourceAsset.tracks(withMediaType: .video).first else {
            return "source_corrupt"
        }

        let compositionTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)

        do {
            try compositionTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: sourceAsset.duration), of: videoTrack, at: .zero)
        } catch {
            return "composition_failed"
        }

        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionTrack!)
        let transform = getRotationTransform(rotationSteps: rotationSteps, videoTrack: videoTrack)
        layerInstruction.setTransform(transform, at: .zero)

        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = videoTrack.naturalSize
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: .zero, duration: composition.duration)
        instruction.layerInstructions = [layerInstruction]
        videoComposition.instructions = [instruction]

        guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
            return "export_session_creation_failed"
        }

        exportSession.outputURL = URL(fileURLWithPath: dstPath)
        exportSession.outputFileType = .mp4
        exportSession.videoComposition = videoComposition

        let semaphore = DispatchSemaphore(value: 0)
        var result: String = ""

        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                result = ""
            case .failed:
                result = "export_failed"
            case .cancelled:
                result = "export_cancelled"
            default:
                result = "unknown_error"
            }
            semaphore.signal()
        }

        semaphore.wait()
        return result
    }

    private static func getRotationTransform(rotationSteps: Int, videoTrack: AVAssetTrack) -> CGAffineTransform {
        let rotationAngle: CGFloat
        switch rotationSteps {
        case 1:
            rotationAngle = .pi / 2
        case 2:
            rotationAngle = .pi
        case 3:
            rotationAngle = 3 * .pi / 2
        default:
            rotationAngle = 0
        }
        return CGAffineTransform(rotationAngle: rotationAngle)
    }
}
