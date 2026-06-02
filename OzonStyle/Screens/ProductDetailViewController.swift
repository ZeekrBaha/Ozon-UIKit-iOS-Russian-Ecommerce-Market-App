import UIKit

// Pushed destination for AppRoute.productDetail. No reference screenshot exists for
// it (outside the 5 mocked surfaces); it deliberately reuses the existing product
// components so the coordinator has a real navigation target.
final class ProductDetailViewController: UIViewController {
    private let product: Product

    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundApp
        title = "Товар"
        navigationItem.largeTitleDisplayMode = .never

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let imageContainer = UIView()
        let image = ProductImageView()
        image.layer.cornerRadius = Layout.cornerImage
        image.backgroundColor = .surfaceCard
        image.configure(named: product.imageName, fitMode: .scaleAspectFit)
        imageContainer.addSubview(image)
        image.pinEdges(to: imageContainer)
        imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor).isActive = true

        let price = PriceBlockView(); price.configure(with: product)
        let title = UI.label(product.title, Typography.sectionTitle, .textPrimary, lines: 0)
        let rating = RatingRowView(); rating.configure(rating: product.rating, reviewCount: product.reviewCount)

        var items: [UIView] = [imageContainer, price, title, rating]
        if let urgency = product.urgency {
            items.append(UI.label(urgency, Typography.secondary, .priceSale))
        }
        items.append(Buttons.cta(date: product.deliveryDate))

        let stack = UI.vStack(items, spacing: 16, alignment: .fill)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: Layout.gutter, left: Layout.gutter,
                                    bottom: Layout.gutter, right: Layout.gutter)
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
