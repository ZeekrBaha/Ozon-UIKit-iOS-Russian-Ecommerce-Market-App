import UIKit

// Asset image with the mandatory placeholder fallback (design.md §3.0, F6/N6):
// a `searchFill` background + centered SF Symbol `photo` when the asset is missing.
final class ProductImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        clipsToBounds = true
        backgroundColor = .searchFill
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }

    func configure(named name: String, fitMode: UIView.ContentMode = .scaleAspectFill) {
        if let img = UIImage(named: name) {
            image = img
            contentMode = fitMode
            tintColor = nil
            backgroundColor = (fitMode == .scaleAspectFit) ? .searchFill : .clear
        } else {
            let cfg = UIImage.SymbolConfiguration(pointSize: 28, weight: .regular)
            image = UIImage(systemName: "photo", withConfiguration: cfg)
            contentMode = .center
            tintColor = .textSecondary
            backgroundColor = .searchFill
        }
    }
}
