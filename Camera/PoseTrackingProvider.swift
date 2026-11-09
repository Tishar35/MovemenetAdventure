import Foundation
import AVFoundation
import CoreGraphics

struct PoseLandmark {
    let name: String
    let point: CGPoint
    let confidence: Float
}

struct PoseSnapshot {
    let landmarks: [String: PoseLandmark]
    let timestamp: TimeInterval
}

protocol PoseTrackingProvider: AnyObject {
    var onPose: ((PoseSnapshot) -> Void)? { get set }
    func start()
    func stop()
}

// MediaPipe adapter seam. Add/link MediaPipe Tasks Vision and the .task model
// before replacing the fallback implementation with SDK-specific calls.
final class MediaPipePoseTrackingProvider: PoseTrackingProvider {
    var onPose: ((PoseSnapshot) -> Void)?
    func start() {
        // Intentionally does not fabricate pose data.
        // Real pose callbacks are emitted only after MediaPipe SDK/model setup.
    }
    func stop() {}
}
