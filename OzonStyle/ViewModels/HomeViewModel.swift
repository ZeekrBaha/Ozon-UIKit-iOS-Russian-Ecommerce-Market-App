import Foundation
import Combine

// Screen 1 state. Owns the carousel index + 3s auto-advance and the live
// sale countdown. No UIKit import.
final class HomeViewModel {
    let banners: [Banner]
    let quickActions: [QuickAction]
    let recommended: [Product]

    @Published private(set) var bannerIndex: Int = 0
    @Published private(set) var saleCountdownText: String
    private var timer: AnyCancellable?
    private var countdownTimer: AnyCancellable?
    private var saleSecondsRemaining: Int

    init(repository: ProductRepository, saleSecondsRemaining: Int = 71113) {
        banners = repository.banners()
        quickActions = repository.quickActions()
        recommended = repository.recommendedProducts()
        self.saleSecondsRemaining = saleSecondsRemaining
        saleCountdownText = Self.countdownText(seconds: saleSecondsRemaining)
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

    // MARK: Sale countdown ("19:45:13 до старта" pill)

    static func countdownText(seconds: Int) -> String {
        let s = max(0, seconds)
        return String(format: "%02d:%02d:%02d", s / 3600, (s % 3600) / 60, s % 60)
    }

    func startSaleCountdown() {
        guard countdownTimer == nil, saleSecondsRemaining > 0 else { return }
        countdownTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.advanceCountdown() }
    }

    func stopSaleCountdown() {
        countdownTimer?.cancel()
        countdownTimer = nil
    }

    func advanceCountdown() {
        guard saleSecondsRemaining > 0 else {
            stopSaleCountdown()
            return
        }
        saleSecondsRemaining -= 1
        saleCountdownText = Self.countdownText(seconds: saleSecondsRemaining)
    }
}
