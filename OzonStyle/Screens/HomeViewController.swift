import UIKit
import Combine

// Screen 1 — Главная. Gradient header (hero inside, red-line #6) + auto-advancing
// carousel + quick-actions rail + "Рекомендуем" grid.
final class HomeViewController: ScrollScreenViewController {
    private let viewModel: HomeViewModel
    private let onSelectProduct: (Product) -> Void
    private var carousel: BannerCarouselView?
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: HomeViewModel, onSelectProduct: @escaping (Product) -> Void) {
        self.viewModel = viewModel
        self.onSelectProduct = onSelectProduct
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentStack.spacing = 20

        contentStack.addArrangedSubview(makeGradientHeader())

        let carousel = BannerCarouselView(banners: viewModel.banners)
        carousel.onScroll = { [weak self] index in self?.viewModel.syncBannerIndex(index) }
        self.carousel = carousel
        contentStack.addArrangedSubview(gutterWrap(carousel))

        contentStack.addArrangedSubview(makeQuickActionsRail())
        contentStack.addArrangedSubview(gutterWrap(SectionHeaderView("Рекомендуем")))
        let grid = ProductGrid.make(products: viewModel.recommended, onSelect: onSelectProduct)
        contentStack.addArrangedSubview(gutterWrap(grid))

        viewModel.$bannerIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in self?.carousel?.setIndex(index) }
            .store(in: &cancellables)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startCarousel()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopCarousel()
    }

    // MARK: Gradient header (logo + city/login + search + hero, all inside gradient)

    private func makeGradientHeader() -> UIView {
        let header = GradientView(colors: [Brand.gradientTop, Brand.gradientBottom],
                                  roundedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])

        let inner = UI.vStack([
            AppLogoHeaderView(),
            makeCityLoginRow(),
            SearchBarView(fill: .white, trailing: [.barcode, .camera]),
            makeHeroRow(),
        ], spacing: 10, alignment: .fill)
        inner.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(inner)

        let top = inner.topAnchor.constraint(equalTo: header.topAnchor)
        registerTopInset(top, extra: 8)
        NSLayoutConstraint.activate([
            top,
            inner.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: Layout.gutter),
            inner.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -Layout.gutter),
            inner.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -20),
        ])
        return header
    }

    private func makeCityLoginRow() -> UIView {
        let city = UI.hStack([
            UI.label("Астана", .systemFont(ofSize: 17, weight: .semibold), .white),
            UI.symbol("chevron.down", .white, size: 13, weight: .semibold),
        ], spacing: 4)
        let login = DarkPillView(UI.label("Войти", .systemFont(ofSize: 15, weight: .semibold), .white),
                                 height: 36, hPadding: 18)
        return UI.hStack([city, UIView(), login], spacing: 8)
    }

    private func makeHeroRow() -> UIView {
        let headline = UI.label("ПРАЗДНИК\nПРИЛЕТИТ", .systemFont(ofSize: 26, weight: .heavy), .white, lines: 2)
        let countdown = DarkPillView(UI.hStack([
            UI.label("19:45:13 до старта", .systemFont(ofSize: 14, weight: .semibold), .white),
            UI.symbol("chevron.right", .white, size: 12, weight: .semibold),
        ], spacing: 8), height: 36, hPadding: 14)
        let countdownBox = UI.hStack([countdown, UIView()], spacing: 0)   // hug left
        let left = UI.vStack([headline, countdownBox], spacing: 10, alignment: .leading)

        let big = UI.label("О!", .systemFont(ofSize: 40, weight: .black), .white)
        let sale = UI.label("РАСПРОДАЖА", .systemFont(ofSize: 18, weight: .heavy), .white)
        let right = UI.vStack([big, sale], spacing: 2, alignment: .trailing)
        right.setContentHuggingPriority(.required, for: .horizontal)

        return UI.hStack([left, UIView(), right], spacing: 8, alignment: .center)
    }

    // MARK: Quick actions rail (horizontal scroll)

    private func makeQuickActionsRail() -> UIView {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        let row = UI.hStack(viewModel.quickActions.map { QuickActionView(action: $0) },
                            spacing: 14, alignment: .top)
        row.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(row)
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
            row.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),
            row.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: Layout.gutter),
            row.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -Layout.gutter),
            row.heightAnchor.constraint(equalTo: scroll.frameLayoutGuide.heightAnchor),
        ])
        return scroll
    }
}
