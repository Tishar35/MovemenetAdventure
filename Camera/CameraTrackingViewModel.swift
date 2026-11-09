
import Foundation
import Combine

@MainActor
final class CameraTrackingViewModel: ObservableObject {

    @Published var status = "Camera not started"
    @Published var lastMovement = "No movement yet"
    @Published var isReady = false

    private let provider: PoseTrackingProvider
    private let classifier = MovementClassifier()

    init(provider: PoseTrackingProvider = MediaPipePoseTrackingProvider()) {
        self.provider = provider

        provider.onPose = { [weak self] pose in
            Task { @MainActor in
                self?.classifier.process(pose)
            }
        }

        classifier.onEvent = { [weak self] event in
            Task { @MainActor in
                self?.lastMovement = event.rawValue
            }
        }
    }

    func start() {
        status = "Camera preview active • Pose model setup required"
        provider.start()
    }

    func stop() {
        provider.stop()
        status = "Tracking paused"
    }
}
