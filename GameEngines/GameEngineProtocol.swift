import Foundation

protocol GameEngineProtocol {
    var level: LevelConfiguration { get }
    var progress: Int { get }
    mutating func handle(_ event: MovementEvent)
    mutating func demoAction()
}

struct UniverseEngine: GameEngineProtocol {
    let level: LevelConfiguration
    private(set) var progress = 0
    mutating func handle(_ event: MovementEvent) {
        guard event == .leftHandRaised || event == .rightHandRaised || event == .leftReach || event == .rightReach else { return }
        progress = min(progress + 1, level.targetCount)
    }
    mutating func demoAction() { progress = min(progress + 1, level.targetCount) }
}

struct JungleEngine: GameEngineProtocol {
    let level: LevelConfiguration
    private(set) var progress = 0
    mutating func handle(_ event: MovementEvent) {
        guard event == .poseHeld || event == .poseChanged || event == .squatDetected || event == .leftReach || event == .rightReach else { return }
        progress = min(progress + 1, level.targetCount)
    }
    mutating func demoAction() { progress = min(progress + 1, level.targetCount) }
}
