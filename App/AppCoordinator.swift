import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var route: AppRoute = .welcome
    @Published var selectedWorld: WorldID = .universe
    @Published var selectedLevel: LevelConfiguration = GameCatalog.universeLevels[0]
    @Published var profile: ChildProfile?
    @Published var isDemoMode = true

    let store = LocalProgressStore.shared

    init() {
        profile = store.loadProfile()
        if profile != nil { route = .hub }
    }

    func startAdventure(nickname: String, age: AgeGroup) {
        var newProfile = profile ?? ChildProfile(nickname: nickname, ageGroup: age)
        newProfile.nickname = nickname
        newProfile.ageGroup = age
        profile = newProfile
        store.saveProfile(newProfile)
        route = .avatar
    }

    func finishAvatar() {
        if var p = profile {
            p.hasCreatedAvatar = true
            profile = p
            store.saveProfile(p)
        }
        route = .hub
    }

    func openWorld(_ world: WorldID) {
        guard world == .universe || world == .jungle else { return }
        selectedWorld = world
        route = .levels
    }

    func startLevel(_ level: LevelConfiguration) {
        selectedLevel = level
        route = .mission
    }

    func beginGameplay() { route = .gameplay }

    func completeLevel(stars: Int) {
        store.complete(level: selectedLevel, stars: stars)
        route = .results
    }

    func goHome() { route = .hub }
}

enum AppRoute {
    case welcome, parentSetup, profile, avatar, hub, levels, mission, gameplay, results, parentDashboard
}
