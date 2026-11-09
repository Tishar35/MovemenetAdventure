import SwiftUI

struct AdventureHubView: View {
    @EnvironmentObject private var app: AppCoordinator
    private var progress: ProgressData { app.store.loadProgress() }

    var body: some View {
        ZStack {
            AppTheme.background(for: .universe).ignoresSafeArea()
            ScrollView {
                VStack(spacing: 22) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hello, \(app.profile?.nickname ?? "Explorer")!").font(.system(size: 30, weight: .black, design: .rounded))
                            Text("Where will your adventure take you?").foregroundStyle(.white.opacity(0.75))
                        }
                        Spacer()
                        Image(systemName: "person.crop.circle.fill").font(.system(size: 54)).foregroundStyle(AppTheme.star)
                    }
                    HStack(spacing: 12) {
                        StatPill(icon: "star.fill", value: "\(progress.totalStars)", label: "Stars")
                        StatPill(icon: "medal.fill", value: "\(progress.badges.count)", label: "Badges")
                    }
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(WorldID.allCases) { world in
                            WorldCard(world: world) { app.openWorld(world) }
                        }
                    }
                    PrimaryActionButton(title: "Continue Adventure") { app.openWorld(.universe) }
                    Button("Parent dashboard") { app.route = .parentDashboard }
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(22)
                .frame(maxWidth: 900)
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct StatPill: View {
    let icon: String
    let value: String
    let label: String
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon).foregroundStyle(AppTheme.star)
            VStack(alignment: .leading, spacing: 0) {
                Text(value).font(.headline.bold())
                Text(label).font(.caption).foregroundStyle(.white.opacity(0.7))
            }
        }
        .padding(12)
        .background(.white.opacity(0.1), in: Capsule())
    }
}

struct LevelMapView: View {
    @EnvironmentObject private var app: AppCoordinator
    private var progress: ProgressData { app.store.loadProgress() }
    private var levels: [LevelConfiguration] { GameCatalog.levels(for: app.selectedWorld) }

    var body: some View {
        ZStack {
            AppTheme.background(for: app.selectedWorld).ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Button { app.goHome() } label: { Label("Hub", systemImage: "chevron.left") }
                        Spacer()
                        Text(app.selectedWorld.title).font(.largeTitle.weight(.black))
                        Spacer()
                        Text("⭐ \(progress.totalStars)")
                    }
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 105), spacing: 12)], spacing: 16) {
                        ForEach(levels) { level in
                            let unlocked = progress.unlockedLevelIDs.contains(level.id) || level.number == 1
                            LevelNode(level: level, unlocked: unlocked, completed: progress.completedLevelIDs.contains(level.id)) {
                                app.startLevel(level)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .padding(20)
                .frame(maxWidth: 900)
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct ParentDashboardView: View {
    @EnvironmentObject private var app: AppCoordinator
    private var progress: ProgressData { app.store.loadProgress() }
    var body: some View {
        ScreenShell(title: "Parent dashboard", subtitle: "A simple overview of this local profile.") {
            VStack(alignment: .leading, spacing: 16) {
                InfoRow(icon: "person.fill", text: "Profile: \(app.profile?.nickname ?? "Not created")")
                InfoRow(icon: "star.fill", text: "Stars earned: \(progress.totalStars)")
                InfoRow(icon: "checkmark.seal.fill", text: "Missions completed: \(progress.completedLevelIDs.count)")
                InfoRow(icon: "lock.shield.fill", text: "Video is not saved by this starter.")
                PrimaryActionButton(title: "Back to Adventure") { app.goHome() }
            }
        }
    }
}
