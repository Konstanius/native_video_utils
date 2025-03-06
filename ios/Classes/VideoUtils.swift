import AVFoundation

class VideoUtils {
    static func trimVideo(srcPath: String, dstPath: String, startMs: Int, endMs: Int) -> String {
        guard let sourceAsset = AVURLAsset(url: URL(fileURLWithPath: srcPath)) else {
            return "source_file_not_found"
        }

        let startTime = CMTime(seconds: Double(startMs) / 1000.0, preferredTimescale: 600)
        let endTime = CMTime(seconds: Double(endMs) / 1000.0, preferredTimescale: 600)

        guard let exportSession = AVAssetExportSession(asset: sourceAsset, presetName: AVAssetExportPresetHighestQuality) else {
            return "export_session_creation_failed"
        }

        exportSession.outputURL = URL(fileURLWithPath: dstPath)
        exportSession.outputFileType = .mp4
        exportSession.timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: endTime)

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
