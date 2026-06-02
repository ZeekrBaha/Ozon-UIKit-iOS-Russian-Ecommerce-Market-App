import Foundation

struct Category: Hashable {
    let id = UUID()
    let title: String
    let imageName: String

    static func == (lhs: Category, rhs: Category) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
