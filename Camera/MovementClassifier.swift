import Foundation
import CoreGraphics

final class MovementClassifier {
    private var previous: PoseSnapshot?
    private var lastEventTime: [MovementEvent: TimeInterval] = [:]
    var cooldown: TimeInterval = 0.7
    var onEvent: ((MovementEvent) -> Void)?

    func process(_ pose: PoseSnapshot) {
        guard let leftWrist = pose.landmarks["leftWrist"],
              let rightWrist = pose.landmarks["rightWrist"],
              let leftShoulder = pose.landmarks["leftShoulder"],
              let rightShoulder = pose.landmarks["rightShoulder"] else {
            previous = pose
            return
        }

        if leftWrist.confidence > 0.55 && leftShoulder.confidence > 0.55 && leftWrist.point.y < leftShoulder.point.y {
            emit(.leftHandRaised, at: pose.timestamp)
        }
        if rightWrist.confidence > 0.55 && rightShoulder.confidence > 0.55 && rightWrist.point.y < rightShoulder.point.y {
            emit(.rightHandRaised, at: pose.timestamp)
        }
        if leftWrist.point.y < leftShoulder.point.y && rightWrist.point.y < rightShoulder.point.y {
            emit(.bothHandsRaised, at: pose.timestamp)
        }
        previous = pose
    }

    private func emit(_ event: MovementEvent, at time: TimeInterval) {
        if let last = lastEventTime[event], time - last < cooldown { return }
        lastEventTime[event] = time
        onEvent?(event)
    }
}
