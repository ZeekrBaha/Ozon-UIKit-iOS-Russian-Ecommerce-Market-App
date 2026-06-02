import Foundation

struct QuickAction: Hashable {
    let id = UUID()
    let title: String
    let imageName: String

    static func == (lhs: QuickAction, rhs: QuickAction) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
