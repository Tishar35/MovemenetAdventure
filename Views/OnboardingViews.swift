import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var app: AppCoordinator
    var body: some View {
        ZStack {
            AppTheme.background(for: .universe).ignoresSafeArea()
            VStack(spacing: 22) {
                Spacer()
                Image(systemName: "sparkles")
                    .font(.system(size: 86, weight: .bold))
                    .foregroundStyle(AppTheme.star)
                    .symbolEffect(.pulse)
                Text("MovementAdventure")
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .multilineTextAlignment(.center)
                Text("Move, Explore, Play!")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(AppTheme.cyan)
                Spacer()
                PrimaryActionButton(title: "Start Adventure") { app.route = .parentSetup }
                Button("Parent settings") { app.route = .parentDashboard }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.8))
                Text("A grown-up should help set up the adventure.")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.65))
            }
            .padding(28)
        }
    }
}

struct ParentSetupView: View {
    @EnvironmentObject private var app: AppCoordinator
    @State private var consent = false
    var body: some View {
        ScreenShell(title: "A note for grown-ups", subtitle: "A safe adventure starts with you.") {
            VStack(alignment: .leading, spacing: 18) {
                InfoRow(icon: "camera.fill", text: "The camera helps the game understand simple body movements.")
                InfoRow(icon: "iphone.gen3", text: "Camera processing is designed to happen on this device. This starter does not record or upload video.")
                InfoRow(icon: "figure.stand", text: "Please supervise play and clear a safe, open space.")
                Toggle("I am the parent or guardian and I consent to camera-based play.", isOn: $consent)
                    .tint(AppTheme.leaf)
                    .padding(.vertical, 8)
                PrimaryActionButton(title: "Continue", color: AppTheme.leaf) {
                    app.route = .profile
                }
                .disabled(!consent)
                .opacity(consent ? 1 : 0.45)
            }
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject private var app: AppCoordinator
    @State private var nickname = ""
    @State private var age: AgeGroup = .fiveToSix
    var body: some View {
        ScreenShell(title: "Who's exploring today?", subtitle: "A nickname is all we need.") {
            VStack(spacing: 18) {
                TextField("Child nickname", text: $nickname)
                    .textFieldStyle(.roundedBorder)
                    .font(.title3)
                Picker("Age range", selection: $age) {
                    ForEach(AgeGroup.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                PrimaryActionButton(title: "Create my avatar", color: AppTheme.cyan) {
                    app.startAdventure(nickname: nickname.trimmingCharacters(in: .whitespaces).isEmpty ? "Explorer" : nickname, age: age)
                }
            }
        }
    }
}

struct AvatarView: View {
    @EnvironmentObject private var app: AppCoordinator
    @State private var character = 0
    @State private var outfit = 0
    private let characters = ["person.fill", "person.crop.circle.fill", "face.smiling.fill"]
    var body: some View {
        ScreenShell(title: "Make your explorer", subtitle: "Choose a look for your adventure.") {
            VStack(spacing: 20) {
                Image(systemName: characters[character])
                    .font(.system(size: 100))
                    .foregroundStyle([AppTheme.cyan, AppTheme.star, AppTheme.coral][character])
                    .frame(height: 130)
                HStack {
                    Button { character = (character + 2) % 3 } label: { Image(systemName: "chevron.left") }
                    Text("Explorer style \(character + 1)").font(.headline)
                    Button { character = (character + 1) % 3 } label: { Image(systemName: "chevron.right") }
                }
                Picker("Outfit", selection: $outfit) {
                    Text("Cosmic").tag(0)
                    Text("Jungle").tag(1)
                    Text("Rainbow").tag(2)
                }.pickerStyle(.segmented)
                PrimaryActionButton(title: "Let's explore!") { app.finishAvatar() }
            }
        }
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon).font(.title2).foregroundStyle(AppTheme.cyan).frame(width: 30)
            Text(text).font(.body).foregroundStyle(.white.opacity(0.9))
        }
    }
}
