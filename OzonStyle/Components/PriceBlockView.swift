import UIKit

// Price lines (design.md §3.3): installment / sale(+old+discount) / urgency.
final class PriceBlockView: UIView {
    private let stack = UI.vStack([], spacing: 3, alignment: .leading)

    init() {
        super.init(frame: .zero)
        addSubview(stack)
        stack.pinEdges(to: self)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }

    func configure(with p: Product) {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Line 1 — installment
        stack.addArrangedSubview(
            UI.label("\(p.installmentPrice) \(p.installmentTerm)", Typography.installment, .priceInstallment)
        )

        // Line 2 — sale price (+ old strikethrough, + discount)
        var line2: [UIView] = [UI.label(p.salePrice, Typography.priceMain, .priceSale)]
        if let old = p.oldPrice {
            let oldLabel = UILabel()
            oldLabel.attributedText = NSAttributedString(string: old, attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.textSecondary,
                .font: Typography.secondary,
            ])
            line2.append(oldLabel)
        }
        if let d = p.discountPercent {
            line2.append(UI.label("-\(d)%", Typography.secondary, .priceSale))
        }
        stack.addArrangedSubview(UI.hStack(line2, spacing: 6))

        // Line 3 — urgency
        if let urgency = p.urgency {
            stack.addArrangedSubview(UI.label(urgency, Typography.secondary, .priceSale))
        }
    }
}
