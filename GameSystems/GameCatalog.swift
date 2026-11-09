import Foundation

enum GameCatalog {
    static let universeLevels: [LevelConfiguration] = [
        level(.universe, 1, "First Stars", "Reach out and collect your first stars", 4),
        level(.universe, 2, "Star Hunt", "Find stars around the galaxy", 5),
        level(.universe, 3, "Colour Quest", "Choose the colour you are asked to find", 5),
        checkpoint(.universe, 3, "Galaxy Rescue", "Rescue the galaxy at your first checkpoint", 6),
        level(.universe, 4, "Moving Stars", "Follow gently moving stars", 6),
        level(.universe, 5, "Disappearing Stars", "Reach for stars before they fade", 6),
        level(.universe, 6, "Double Trouble", "Alternate between left and right", 7),
        checkpoint(.universe, 6, "Asteroid Attack", "Collect stars and avoid decoys", 7),
        level(.universe, 7, "Memory Galaxy", "Remember a short star sequence", 7),
        level(.universe, 8, "Cosmic Challenge", "Follow a colour sequence", 8),
        level(.universe, 9, "Master Explorer", "Combine your favourite moves", 8),
        checkpoint(.universe, 9, "Save the Galaxy", "Restore the galaxy together", 9),
        level(.universe, 10, "Galaxy Champion", "Celebrate your final space adventure", 10)
    ]

    static let jungleLevels: [LevelConfiguration] = [
        level(.jungle, 1, "Flamingo Friends", "Copy a friendly flamingo pose", 3),
        level(.jungle, 2, "Frog Friends", "Bend gently and stand tall", 4),
        level(.jungle, 3, "Monkey Business", "Reach for jungle branches", 5),
        checkpoint(.jungle, 3, "Animal Parade", "Copy three animal poses", 5),
        level(.jungle, 4, "Tiger Territory", "Switch between tall and low poses", 5),
        level(.jungle, 5, "Balancing Bridge", "Hold a comfortable steady pose", 5),
        level(.jungle, 6, "Animal Switch", "Change poses when animals change", 6),
        checkpoint(.jungle, 6, "Jungle Showdown", "Combine your jungle moves", 6),
        level(.jungle, 7, "Remember the Animals", "Remember a short animal sequence", 6),
        level(.jungle, 8, "Jungle Freeze", "Move and freeze with the signal", 7),
        level(.jungle, 9, "Ultimate Animal Quest", "Combine your favourite poses", 7),
        checkpoint(.jungle, 9, "King of the Jungle", "Complete the great jungle mission", 8),
        level(.jungle, 10, "Jungle Champion", "Celebrate your jungle adventure", 9)
    ]

    static func levels(for world: WorldID) -> [LevelConfiguration] {
        world == .jungle ? jungleLevels : universeLevels
    }

    private static func level(_ world: WorldID, _ number: Int, _ title: String, _ subtitle: String, _ count: Int) -> LevelConfiguration {
        LevelConfiguration(id: "\(world.rawValue)-\(number)", world: world, number: number, title: title, subtitle: subtitle, targetCount: count, requiredEvents: world == .universe ? ["leftReach", "rightReach"] : ["poseHeld", "poseChanged"])
    }

    private static func checkpoint(_ world: WorldID, _ after: Int, _ title: String, _ subtitle: String, _ count: Int) -> LevelConfiguration {
        LevelConfiguration(id: "\(world.rawValue)-checkpoint-\(after)", world: world, number: after, title: title, subtitle: subtitle, isCheckpoint: true, targetCount: count, requiredEvents: ["leftReach", "rightReach"])
    }
}
