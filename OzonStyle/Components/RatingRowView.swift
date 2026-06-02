import UIKit

// ★ rating + ru-pluralized review count (design.md §3.4).
final class RatingRowView: UIView {
    private let stack = UI.hStack([], spacing: 4)

    init() {
        super.init(frame: .zero)
        addSubview(stack)
        stack.pinEdges(to: self)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }

    func configure(rating: Double, reviewCount: Int) {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let ratingLabel = UI.label(String(format: "%.1f", rating),
                                   .systemFont(ofSize: 13, weight: .bold), .textPrimary)
        stack.addArrangedSubview(UI.symbol("star.fill", .ratingStar, size: 13))
        stack.addArrangedSubview(ratingLabel)
        stack.addArrangedSubview(UI.symbol("bubble.left", .textSecondary, size: 13))
        stack.addArrangedSubview(UI.label("\(reviewCount) \(Self.reviewWord(reviewCount))",
                                          Typography.secondary, .textSecondary))
        stack.addArrangedSubview(UIView())   // trailing spacer
    }

    // 1→отзыв, 2–4→отзыва, else→отзывов; teen exception 11–14→отзывов.
    static func reviewWord(_ n: Int) -> String {
        if (11...14).contains(n % 100) { return "отзывов" }
        switch n % 10 {
        case 1:       return "отзыв"
        case 2, 3, 4: return "отзыва"
        default:      return "отзывов"
        }
    }
}
