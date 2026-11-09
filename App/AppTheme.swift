import SwiftUI

enum AppTheme {
    static let cosmic = Color(red: 0.055, green: 0.075, blue: 0.22)
    static let purple = Color(red: 0.36, green: 0.22, blue: 0.68)
    static let cyan = Color(red: 0.22, green: 0.82, blue: 0.98)
    static let star = Color(red: 1.0, green: 0.82, blue: 0.25)
    static let jungle = Color(red: 0.08, green: 0.34, blue: 0.22)
    static let leaf = Color(red: 0.35, green: 0.78, blue: 0.36)
    static let coral = Color(red: 1.0, green: 0.43, blue: 0.32)

    static func background(for world: WorldID) -> LinearGradient {
        switch world {
        case .universe:
            return LinearGradient(colors: [cosmic, purple, Color(red: 0.12, green: 0.12, blue: 0.35)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .jungle:
            return LinearGradient(colors: [jungle, Color(red: 0.12, green: 0.52, blue: 0.31), Color(red: 0.04, green: 0.22, blue: 0.18)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .land:
            return LinearGradient(colors: [.brown, .orange], startPoint: .top, endPoint: .bottom)
        case .ocean:
            return LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom)
        }
    }
}

struct PrimaryActionButton: View {
    let title: String
    var color: Color = AppTheme.star
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .foregroundStyle(.black.opacity(0.85))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 17)
                .background(color, in: Capsule())
                .shadow(color: color.opacity(0.35), radius: 12, y: 6)
        }
        .buttonStyle(.plain)
    }
}
