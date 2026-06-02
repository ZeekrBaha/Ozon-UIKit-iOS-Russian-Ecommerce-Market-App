import UIKit

// Quick-action tile (design.md §3.8): 56pt rounded image + 2-line caption. Fixed
// width so captions wrap consistently in the horizontal rail.
final class QuickActionView: UIView {
    init(action: QuickAction) {
        super.init(frame: .zero)

        let tile = ProductImageView()
        tile.layer.cornerRadius = 14
        tile.configure(named: action.imageName)
        tile.translatesAutoresizingMaskIntoConstraints = false
        tile.widthAnchor.constraint(equalToConstant: 56).isActive = true
        tile.heightAnchor.constraint(equalToConstant: 56).isActive = true

        let caption = UI.label(action.title, Typography.secondary, .textPrimary, lines: 2)
        caption.textAlignment = .center

        let stack = UI.vStack([tile, caption], spacing: 6, alignment: .center)
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        stack.pinEdges(to: self)
        widthAnchor.constraint(equalToConstant: 76).isActive = true
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }
}
