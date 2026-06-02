import Foundation

struct SettingsItem: Hashable {
    let id = UUID()
    let title: String
    let value: String?

    static func == (lhs: SettingsItem, rhs: SettingsItem) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
