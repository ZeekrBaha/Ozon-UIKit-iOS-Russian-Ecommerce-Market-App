import UIKit

enum ProductCardVariant {
    case grid, featuredCompact, viewedGrid
}

// The keystone card (design.md §3.2, red-line #7). One view renders every product
// surface; the screen decides the outer width per variant. The whole card is one
// tappable accessibility element ("productCard") that fires `onTap` → coordinator.
final class ProductCardView: UIView {
    private let onTap: () -> Void

    init(product: Product, variant: ProductCardVariant = .grid, onTap: @escaping () -> Void = {}) {
        self.onTap = onTap
        super.init(frame: .zero)
        backgroundColor = .surfaceCard
        layer.cornerRadius = Layout.cornerCard
        layer.masksToBounds = true

        let imageContainer = makeImageBlock(product: product)
        let price = PriceBlockView(); price.configure(with: product)
        let title = UI.label(product.title, Typography.cardTitle, .textPrimary, lines: 2)
        let rating = RatingRowView(); rating.configure(rating: product.rating, reviewCount: product.reviewCount)
        let cta = Buttons.cta(date: product.deliveryDate)

        let stack = UI.vStack([imageContainer, price, title, rating, cta], spacing: 8, alignment: .fill)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        addSubview(stack)
        stack.pinEdges(to: self)

        isAccessibilityElement = true
        accessibilityIdentifier = "productCard"
        accessibilityTraits = .button
        accessibilityLabel = product.title
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }

    @objc private func handleTap() { onTap() }

    // MARK: Image block (1:1) + heart / badge / page-dots overlays

    private func makeImageBlock(product: Product) -> UIView {
        let container = UIView()
        let image = ProductImageView()
        image.layer.cornerRadius = Layout.cornerImage
        image.configure(named: product.imageName)
        container.addSubview(image)
        image.pinEdges(to: container)
        container.heightAnchor.constraint(equalTo: container.widthAnchor).isActive = true

        addHeart(to: container, isFavorite: product.isFavorite)
        if product.badge == .salesOfWeek { addBadge(to: container) }
        if product.imageCount > 1 { addDots(to: container, count: product.imageCount) }
        return container
    }

    private func addHeart(to container: UIView, isFavorite: Bool) {
        let bg = UIView()
        bg.backgroundColor = isFavorite ? .clear : UIColor.white.withAlphaComponent(0.85)
        bg.layer.cornerRadius = 15
        bg.translatesAutoresizingMaskIntoConstraints = false
        let heart = UI.symbol(isFavorite ? "heart.fill" : "heart",
                              isFavorite ? .priceSale : .white, size: 18)
        heart.translatesAutoresizingMaskIntoConstraints = false
        bg.addSubview(heart)
        container.addSubview(bg)
        NSLayoutConstraint.activate([
            bg.widthAnchor.constraint(equalToConstant: 30),
            bg.heightAnchor.constraint(equalToConstant: 30),
            bg.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            bg.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            heart.centerXAnchor.constraint(equalTo: bg.centerXAnchor),
            heart.centerYAnchor.constraint(equalTo: bg.centerYAnchor),
        ])
    }

    private func addBadge(to container: UIView) {
        let flame = UI.symbol("flame.fill", .white, size: 10, weight: .bold)
        let label = UI.label("СКИДКИ НЕДЕЛИ", Typography.badge, .white)
        let row = UI.hStack([flame, label], spacing: 4)
        let capsule = UIView()
        capsule.backgroundColor = .priceSale
        capsule.layer.cornerRadius = 11
        capsule.translatesAutoresizingMaskIntoConstraints = false
        capsule.addSubview(row)
        row.pinEdges(to: capsule, insets: .init(top: 5, left: 8, bottom: 5, right: 8))
        container.addSubview(capsule)
        NSLayoutConstraint.activate([
            capsule.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            capsule.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
        ])
    }

    private func addDots(to container: UIView, count: Int) {
        let dots: [UIView] = (0..<min(count, 8)).map { i in
            let dot = UIView()
            dot.backgroundColor = (i == 0) ? .brandPrimary : UIColor.white.withAlphaComponent(0.7)
            dot.layer.cornerRadius = 2.5
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.widthAnchor.constraint(equalToConstant: 5).isActive = true
            dot.heightAnchor.constraint(equalToConstant: 5).isActive = true
            return dot
        }
        let row = UI.hStack(dots, spacing: 4)
        container.addSubview(row)
        row.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            row.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            row.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
        ])
    }
}
