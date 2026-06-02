import UIKit

// Base for the 5 tab screens: a vertical scroll view + content stack, dynamic safe-
// area top insets (so headers can bleed under the status bar while content starts at
// safeAreaTop + 8), and nav-bar hiding for root screens.
class ScrollScreenViewController: UIViewController {
    let scrollView = UIScrollView()
    let contentStack = UIStackView()
    var hidesNavBar = true

    private var topInsetConstraints: [(NSLayoutConstraint, CGFloat)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundApp
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.alignment = .fill
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(hidesNavBar, animated: animated)
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        for (c, extra) in topInsetConstraints { c.constant = view.safeAreaInsets.top + extra }
        scrollView.contentInset.bottom = view.safeAreaInsets.bottom + 12
    }

    // MARK: Layout helpers

    func registerTopInset(_ c: NSLayoutConstraint, extra: CGFloat) {
        topInsetConstraints.append((c, extra))
        c.constant = view.safeAreaInsets.top + extra
    }

    /// A spacer whose height tracks `safeAreaTop + extra` (for non-bleeding screens).
    func topInsetSpacer(extra: CGFloat = 8) -> UIView {
        let v = UIView()
        let h = v.heightAnchor.constraint(equalToConstant: extra)
        h.isActive = true
        registerTopInset(h, extra: extra)
        return v
    }

    func spacer(_ height: CGFloat) -> UIView {
        let v = UIView()
        v.heightAnchor.constraint(equalToConstant: height).isActive = true
        return v
    }

    /// Wrap a view with horizontal gutter insets (and optional vertical padding).
    func gutterWrap(_ inner: UIView, top: CGFloat = 0, bottom: CGFloat = 0) -> UIView {
        let c = UIView()
        c.addSubview(inner)
        inner.pinEdges(to: c, insets: .init(top: top, left: Layout.gutter, bottom: bottom, right: Layout.gutter))
        return c
    }

    /// N-column grid of arbitrary equal-width cards.
    func rowsGrid(_ cards: [UIView], columns: Int, spacing: CGFloat = Layout.gridSpacing) -> UIStackView {
        var padded = cards
        let remainder = padded.count % columns
        if remainder != 0 { (0..<(columns - remainder)).forEach { _ in padded.append(UIView()) } }
        let rows = stride(from: 0, to: padded.count, by: columns).map { start -> UIStackView in
            let row = UIStackView(arrangedSubviews: Array(padded[start..<start + columns]))
            row.axis = .horizontal
            row.spacing = spacing
            row.distribution = .fillEqually
            row.alignment = .fill
            return row
        }
        let grid = UIStackView(arrangedSubviews: rows)
        grid.axis = .vertical
        grid.spacing = spacing
        grid.alignment = .fill
        return grid
    }
}
