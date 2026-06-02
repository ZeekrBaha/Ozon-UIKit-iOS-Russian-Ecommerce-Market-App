import Foundation
import Combine

// Screen 1 state. Owns the carousel index + 3s auto-advance. No UIKit import.
final class HomeViewModel {
    let banners: [Banner]
    let quickActions: [QuickAction]
    let recommended: [Product]

    @Published private(set) var bannerIndex: Int = 0
    private var timer: AnyCancellable?

    init(repository: ProductRepository) {
        banners = repository.banners()
        quickActions = repository.quickActions()
        recommended = repository.recommendedProducts()
    }

    func startCarousel() {
        guard timer == nil, banners.count > 1 else { return }
        timer = Timer.publish(every: 3, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.advanceBanner() }
    }

    func stopCarousel() {
        timer?.cancel()
        timer = nil
    }

    func advanceBanner() {
        guard !banners.isEmpty else { return }
        bannerIndex = (bannerIndex + 1) % banners.count
    }

    // Keep state in sync when the user scrolls the carousel by hand.
    func syncBannerIndex(_ index: Int) {
        guard index != bannerIndex, banners.indices.contains(index) else { return }
        bannerIndex = index
    }
}
