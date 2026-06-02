import UIKit

// Leading-aligned section title (design.md §3.10). The screen provides the gutter
// inset; this view just hosts the label.
final class SectionHeaderView: UIView {
    init(_ title: String) {
        super.init(frame: .zero)
        let label = UI.label(title, Typography.sectionTitle, .textPrimary, lines: 0)
        addSubview(label)
        label.pinEdges(to: self)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }
}
