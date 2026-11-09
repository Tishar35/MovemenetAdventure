import SwiftUI
import SpriteKit

struct MissionView: View {
    @EnvironmentObject private var app: AppCoordinator
    @StateObject private var camera = CameraManager()
    var body: some View {
        ScreenShell(title: app.selectedLevel.title, subtitle: app.selectedLevel.subtitle) {
            VStack(spacing: 18) {
                Image(systemName: app.selectedWorld == .universe ? "sparkles" : "pawprint.fill")
                    .font(.system(size: 76)).foregroundStyle(AppTheme.star)
                Text(app.selectedWorld == .universe ? "Reach toward the glowing stars!" : "Copy the friendly animal pose!")
                    .font(.title3.bold()).multilineTextAlignment(.center)
                HStack {
                    Button("DEMO MODE") { app.isDemoMode = true; app.beginGameplay() }
                        .buttonStyle(.borderedProminent)
                        .tint(AppTheme.coral)
                    Button("Camera setup") { camera.requestPermissionAndStart() }
                        .buttonStyle(.bordered)
                }
                if let error = camera.errorMessage {
                    Text(error).font(.caption).foregroundStyle(.yellow)
                }
                Text("Make sure you have a clear, comfortable space and a grown-up nearby.")
                    .font(.caption).foregroundStyle(.white.opacity(0.7)).multilineTextAlignment(.center)
            }
        }
        .onDisappear { camera.stop() }
    }
}

struct GameplayView: View {
    @EnvironmentObject private var app: AppCoordinator
    @State private var collected = 0
    @State private var showPause = false
    @State private var scene = AdventureScene(size: CGSize(width: 900, height: 500))

    var body: some View {
        GeometryReader { geo in
            ZStack {
                AppTheme.background(for: app.selectedWorld).ignoresSafeArea()
                VStack(spacing: 10) {
                    HStack {
                        Button { showPause = true } label: { Image(systemName: "pause.fill").font(.title2).padding(12).background(.white.opacity(0.15), in: Circle()) }
                        Spacer()
                        Text(app.selectedLevel.title).font(.title2.bold())
                        Spacer()
                        Text("\(collected)/\(app.selectedLevel.targetCount) ⭐").font(.headline)
                    }
                    .padding(.horizontal)
                    SpriteView(scene: scene)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .padding(.horizontal, 12)
                    HStack(spacing: 12) {
                        Button("← Reach") { demoMovement() }
                        Button("Raise both hands") { demoMovement() }
                        Button("Reach →") { demoMovement() }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.cyan)
                    Text("DEMO MODE • Touch controls simulate movement; this is not camera recognition.")
                        .font(.caption2).foregroundStyle(.white.opacity(0.7))
                        .padding(.bottom, 8)
                }
                .padding(.top, 8)
                if showPause {
                    Color.black.opacity(0.65).ignoresSafeArea()
                    VStack(spacing: 18) {
                        Text("Adventure paused").font(.largeTitle.bold())
                        Button("Resume") { showPause = false }.buttonStyle(.borderedProminent)
                        Button("Return to Hub") { app.goHome() }.tint(.white)
                    }
                    .padding(30)
                    .background(AppTheme.cosmic, in: RoundedRectangle(cornerRadius: 24))
                }
            }
            .onAppear {
                scene.size = CGSize(width: max(geo.size.width, 600), height: max(geo.size.height * 0.68, 300))
                scene.scaleMode = .resizeFill
                scene.onTargetCollected = { collected += 1 }
            }
            .onChange(of: collected) { _, value in
                if value >= app.selectedLevel.targetCount {
                    app.completeLevel(stars: 3)
                }
            }
        }
        .statusBarHidden()
    }

    private func demoMovement() {
        scene.collectTarget()
    }
}

struct ResultsView: View {
    @EnvironmentObject private var app: AppCoordinator
    var body: some View {
        ScreenShell(title: "Amazing work!", subtitle: "You completed \(app.selectedLevel.title).") {
            VStack(spacing: 18) {
                Image(systemName: "trophy.fill").font(.system(size: 90)).foregroundStyle(AppTheme.star)
                Text("⭐⭐⭐").font(.system(size: 36))
                Text("You earned 3 stars!").font(.title2.bold())
                PrimaryActionButton(title: "Next Adventure") {
                    let ordered = GameCatalog.levels(for: app.selectedWorld)
                    if let index = ordered.firstIndex(where: { $0.id == app.selectedLevel.id }),
                       ordered.indices.contains(index + 1) {
                        app.startLevel(ordered[index + 1])
                    } else {
                        app.goHome()
                    }
                }
                Button("Return to World") { app.route = .levels }.foregroundStyle(.white)
                Button("Adventure Hub") { app.goHome() }.foregroundStyle(.white.opacity(0.75))
            }
        }
    }
}
