import UIKit

// Auto-advancing paged banner carousel (design.md Screen 1 / §6). Encapsulates a
// horizontal paging collection view + page dots. Index is driven by HomeViewModel
// (`setIndex`); user swipes are reported back via `onScroll`.
final class BannerCarouselView: UIView {
    private let banners: [Banner]
    private let pageControl = UIPageControl()
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.reuseID)
        return cv
    }()

    var onScroll: ((Int) -> Void)?

    init(banners: [Banner]) {
        self.banners = banners
        super.init(frame: .zero)
        layer.cornerRadius = Layout.cornerBanner
        layer.masksToBounds = true

        addSubview(collection)
        collection.pinEdges(to: self)

        pageControl.numberOfPages = banners.count
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.isUserInteractionEnabled = false
        addSubview(pageControl)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Layout.bannerHeight),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }

    func setIndex(_ index: Int, animated: Bool = true) {
        guard banners.indices.contains(index) else { return }
        collection.scrollToItem(at: IndexPath(item: index, section: 0),
                                at: .centeredHorizontally, animated: animated)
        pageControl.currentPage = index
    }
}

extension BannerCarouselView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        banners.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BannerCell.reuseID, for: indexPath) as? BannerCell else {
            assertionFailure("BannerCell is not registered for \(BannerCell.reuseID)")
            return UICollectionViewCell()
        }
        cell.configure(named: banners[indexPath.item].imageName)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / max(scrollView.bounds.width, 1)))
        pageControl.currentPage = page
        onScroll?(page)
    }
}

private final class BannerCell: UICollectionViewCell {
    static let reuseID = "BannerCell"
    private let imageView = ProductImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.pinEdges(to: contentView)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }
    func configure(named name: String) {
        imageView.configure(named: name, fitMode: .scaleAspectFill)
    }
}
