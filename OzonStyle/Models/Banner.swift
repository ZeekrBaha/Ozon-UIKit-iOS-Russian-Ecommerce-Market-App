import Foundation

// Home carousel banner — a full-bleed promo image.
struct Banner: Hashable {
    let id = UUID()
    let imageName: String

    static func == (lhs: Banner, rhs: Banner) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
