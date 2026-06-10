import XCTest
@testable import OzonStyle

// Reusable stub — every ProductRepository method returns controllable data.
struct StubRepository: ProductRepository {
    var stubBanners: [Banner] = []
    func banners() -> [Banner] { stubBanners }
    func quickActions() -> [QuickAction] { [] }
    func recommendedProducts() -> [Product] { [] }
    func viewedProducts() -> [Product] { [] }
    func featuredFavorite() -> Product { .fixture }
    func categories() -> [OzonStyle.Category] { [] }
    func settings() -> [SettingsItem] { [] }
}

extension Product {
    static let fixture = Product(
        imageName: "x", imageCount: 1, isFavorite: false, badge: nil,
        installmentPrice: "1 ₸", installmentTerm: "×12 мес", salePrice: "1 ₸",
        oldPrice: nil, discountPercent: nil, urgency: nil, title: "t",
        rating: 5, reviewCount: 1, deliveryDate: "1 июня")
}

final class HomeViewModelTests: XCTestCase {
    private func makeViewModel(bannerCount: Int = 3) -> HomeViewModel {
        let banners = (0..<bannerCount).map { Banner(imageName: "b\($0)") }
        return HomeViewModel(repository: StubRepository(stubBanners: banners))
    }

    func testInitReadsBannersFromRepository() {
        XCTAssertEqual(makeViewModel(bannerCount: 3).banners.count, 3)
    }

    func testAdvanceBannerWrapsToZeroAfterLastBanner() {
        let vm = makeViewModel(bannerCount: 3)
        vm.advanceBanner()  // 1
        vm.advanceBanner()  // 2
        vm.advanceBanner()  // wraps
        XCTAssertEqual(vm.bannerIndex, 0)
    }

    func testAdvanceBannerWithNoBannersKeepsIndexZero() {
        let vm = makeViewModel(bannerCount: 0)
        vm.advanceBanner()
        XCTAssertEqual(vm.bannerIndex, 0)
    }

    func testSyncBannerIndexAcceptsValidIndex() {
        let vm = makeViewModel(bannerCount: 3)
        vm.syncBannerIndex(2)
        XCTAssertEqual(vm.bannerIndex, 2)
    }

    func testSyncBannerIndexIgnoresOutOfBoundsIndex() {
        let vm = makeViewModel(bannerCount: 3)
        vm.syncBannerIndex(5)
        XCTAssertEqual(vm.bannerIndex, 0)
        vm.syncBannerIndex(-1)
        XCTAssertEqual(vm.bannerIndex, 0)
    }

    // MARK: Sale countdown

    func testCountdownTextFormatsHoursMinutesSeconds() {
        XCTAssertEqual(HomeViewModel.countdownText(seconds: 71113), "19:45:13")
        XCTAssertEqual(HomeViewModel.countdownText(seconds: 0), "00:00:00")
        XCTAssertEqual(HomeViewModel.countdownText(seconds: 61), "00:01:01")
    }

    func testCountdownTextClampsNegativeToZero() {
        XCTAssertEqual(HomeViewModel.countdownText(seconds: -5), "00:00:00")
    }

    func testInitialCountdownTextUsesSeededSeconds() {
        let vm = HomeViewModel(repository: StubRepository(), saleSecondsRemaining: 3661)
        XCTAssertEqual(vm.saleCountdownText, "01:01:01")
    }

    func testAdvanceCountdownDecrementsOneSecond() {
        let vm = HomeViewModel(repository: StubRepository(), saleSecondsRemaining: 2)
        vm.advanceCountdown()
        XCTAssertEqual(vm.saleCountdownText, "00:00:01")
    }

    func testAdvanceCountdownStopsAtZero() {
        let vm = HomeViewModel(repository: StubRepository(), saleSecondsRemaining: 1)
        vm.advanceCountdown()
        vm.advanceCountdown()
        vm.advanceCountdown()
        XCTAssertEqual(vm.saleCountdownText, "00:00:00")
    }
}
