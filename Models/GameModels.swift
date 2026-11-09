import Foundation

enum WorldID: String, Codable, CaseIterable, Identifiable {
    case universe, jungle, land, ocean
    var id: String { rawValue }
    var title: String { rawValue.capitalized }
    var symbol: String {
        switch self { case .universe: "sparkles"; case .jungle: "leaf.fill"; case .land: "mountain.2.fill"; case .ocean: "water.waves" }
    }
    var isAvailable: Bool { self == .universe || self == .jungle }
}

enum AgeGroup: String, Codable, CaseIterable, Identifiable {
    case fiveToSix = "5–6"
    case sevenToEight = "7–8"
    var id: String { rawValue }
}

struct Avatar: Codable {
    var characterIndex = 0
    var skinToneIndex = 0
    var outfitIndex = 0
    var accessoryIndex = 0
}

struct ChildProfile: Codable {
    var nickname: String
    var ageGroup: AgeGroup
    var avatar = Avatar()
    var hasCreatedAvatar = false
}

struct LevelConfiguration: Identifiable, Codable, Hashable {
    var id: String
    var world: WorldID
    var number: Int
    var title: String
    var subtitle: String
    var isCheckpoint: Bool = false
    var targetCount: Int
    var requiredEvents: [String]
}

struct ProgressData: Codable {
    var completedLevelIDs: Set<String> = []
    var unlockedLevelIDs: Set<String> = ["universe-1", "jungle-1"]
    var totalStars: Int = 0
    var badges: [String] = []
}

enum MovementEvent: String, Codable {
    case leftHandRaised, rightHandRaised, bothHandsRaised
    case leftReach, rightReach, squatDetected, poseHeld, poseChanged
    case bodyShiftedLeft, bodyShiftedRight
}
