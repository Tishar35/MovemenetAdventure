import SwiftUI

struct ScreenShell<Content: View>: View {
    let title: String
    let subtitle: String
    @ViewBuilder var content: Content
    var body: some View {
        ZStack {
            AppTheme.background(for: .universe).ignoresSafeArea()
            VStack(spacing: 20) {
                VStack(spacing: 6) {
                    Text(title).font(.system(size: 30, weight: .black, design: .rounded)).multilineTextAlignment(.center)
                    Text(subtitle).font(.subheadline).foregroundStyle(.white.opacity(0.72)).multilineTextAlignment(.center)
                }
                content
                Spacer(minLength: 0)
            }
            .padding(24)
            .frame(maxWidth: 680)
        }
    }
}

struct WorldCard: View {
    let world: WorldID
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: world.symbol).font(.system(size: 42, weight: .bold))
                Text(world.title).font(.title2.weight(.black))
                Text(world.isAvailable ? (world == .universe ? "Star Collector" : "Animal Rescue") : "Coming soon")
                    .font(.caption.weight(.semibold))
                if !world.isAvailable { Image(systemName: "lock.fill").font(.caption) }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: 145)
            .background(AppTheme.background(for: world), in: RoundedRectangle(cornerRadius: 24))
            .overlay(RoundedRectangle(cornerRadius: 24).stroke(.white.opacity(0.22), lineWidth: 1))
        }
        .buttonStyle(.plain)
        .disabled(!world.isAvailable)
        .opacity(world.isAvailable ? 1 : 0.55)
    }
}

struct LevelNode: View {
    let level: LevelConfiguration
    let unlocked: Bool
    let completed: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(spacing: 7) {
                ZStack {
                    Circle().fill(completed ? AppTheme.leaf : (unlocked ? AppTheme.star : .gray.opacity(0.4)))
                        .frame(width: 66, height: 66)
                    Image(systemName: completed ? "checkmark" : (unlocked ? "star.fill" : "lock.fill"))
                        .font(.title2.weight(.black))
                        .foregroundStyle(.black.opacity(0.8))
                }
                Text(level.title).font(.caption.weight(.bold)).multilineTextAlignment(.center).lineLimit(2)
            }
            .frame(width: 105, height: 110)
        }
        .buttonStyle(.plain)
        .disabled(!unlocked)
        .opacity(unlocked ? 1 : 0.5)
    }
}
