import SwiftUI

struct RootView: View {
    @EnvironmentObject private var app: AppCoordinator

    var body: some View {
        Group {
            switch app.route {
            case .welcome: WelcomeView()
            case .parentSetup: ParentSetupView()
            case .profile: ProfileView()
            case .avatar: AvatarView()
            case .hub: AdventureHubView()
            case .levels: LevelMapView()
            case .mission: MissionView()
            case .gameplay: GameplayView()
            case .results: ResultsView()
            case .parentDashboard: ParentDashboardView()
            }
        }
        .animation(.easeInOut(duration: 0.25), value: routeKey)
    }

    private var routeKey: Int {
        switch app.route {
        case .welcome: 0; case .parentSetup: 1; case .profile: 2; case .avatar: 3
        case .hub: 4; case .levels: 5; case .mission: 6; case .gameplay: 7
        case .results: 8; case .parentDashboard: 9
        }
    }
}
