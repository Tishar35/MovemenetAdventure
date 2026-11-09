import Foundation

final class LocalProgressStore {
    static let shared = LocalProgressStore()
    private let profileKey = "movementAdventure.profile.v1"
    private let progressKey = "movementAdventure.progress.v1"
    private let defaults = UserDefaults.standard

    func loadProfile() -> ChildProfile? {
        guard let data = defaults.data(forKey: profileKey) else { return nil }
        return try? JSONDecoder().decode(ChildProfile.self, from: data)
    }

    func saveProfile(_ profile: ChildProfile) {
        guard let data = try? JSONEncoder().encode(profile) else { return }
        defaults.set(data, forKey: profileKey)
    }

    func loadProgress() -> ProgressData {
        guard let data = defaults.data(forKey: progressKey),
              let progress = try? JSONDecoder().decode(ProgressData.self, from: data) else { return ProgressData() }
        return progress
    }

    func complete(level: LevelConfiguration, stars: Int) {
        var progress = loadProgress()
        progress.completedLevelIDs.insert(level.id)
        progress.totalStars += stars

        let orderedLevels = GameCatalog.levels(for: level.world)
        if let currentIndex = orderedLevels.firstIndex(where: { $0.id == level.id }),
           orderedLevels.indices.contains(currentIndex + 1) {
            progress.unlockedLevelIDs.insert(orderedLevels[currentIndex + 1].id)
        }

        if level.isCheckpoint {
            progress.badges.append(level.title)
        }

        if let data = try? JSONEncoder().encode(progress) {
            defaults.set(data, forKey: progressKey)
        }
    }
}
