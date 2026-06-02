import XCTest

// Layout / geometry tests — the visual red-lines automated as XCUIElement.frame
// assertions (no pixel-snapshot library → dependency-free).
final class LayoutUITests: XCTestCase {

    private var app: XCUIApplication!
    private var window: CGRect!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.windows.firstMatch.waitForExistence(timeout: 5))
        window = app.windows.firstMatch.frame
    }

    private func openTab(_ label: String) {
        let tab = app.tabBars.buttons[label]
        XCTAssertTrue(tab.waitForExistence(timeout: 5), "Tab \"\(label)\" not found")
        tab.tap()
    }

    private func anyElement(_ id: String) -> XCUIElement {
        app.descendants(matching: .any).matching(identifier: id).firstMatch
    }

    func testTabBarPinnedToBottom() {
        let bar = app.tabBars.firstMatch
        XCTAssertTrue(bar.waitForExistence(timeout: 5), "Tab bar missing")
        XCTAssertEqual(bar.frame.maxY, window.maxY, accuracy: 2, "Tab bar not at bottom edge")
        XCTAssertGreaterThan(bar.frame.minY, window.height * 0.8, "Tab bar too tall / not at bottom")
    }

    // Red-line #1 — brand pill below the safe area, horizontally centered.
    func testLogoPillBelowSafeAreaAndCentered() {
        let pill = anyElement("brandPill")
        XCTAssertTrue(pill.waitForExistence(timeout: 5), "Brand pill missing")
        XCTAssertGreaterThanOrEqual(pill.frame.minY, 24, "Pill overlaps the status bar / island")
        XCTAssertLessThan(pill.frame.minY, window.height * 0.3, "Pill not near the top")
        XCTAssertEqual(pill.frame.midX, window.midX, accuracy: 6, "Pill not centered")
    }

    // Red-line #2 — Favorites featured card compact (< 60% width) + left-aligned.
    func testFavoritesFeaturedIsCompactLeftAligned() {
        openTab("Избранное")
        let featured = app.buttons.matching(identifier: "productCard").firstMatch
        XCTAssertTrue(featured.waitForExistence(timeout: 5), "Featured card missing")
        XCTAssertLessThan(featured.frame.width, window.width * 0.6, "Featured card not compact")
        XCTAssertLessThan(featured.frame.minX, window.width * 0.25, "Featured card not left-aligned")
    }

    // Red-line #3 — Cart empty state is a full-width band.
    func testCartEmptyBandFullWidth() {
        openTab("Корзина")
        let band = anyElement("cartEmptyBand")
        XCTAssertTrue(band.waitForExistence(timeout: 5), "Empty band missing")
        XCTAssertGreaterThan(band.frame.width, window.width * 0.9, "Empty band is not full-width")
    }

    // Home "Рекомендуем" grid is 2 columns.
    func testHomeGridIsTwoColumn() {
        let cards = app.buttons.matching(identifier: "productCard")
        XCTAssertTrue(cards.firstMatch.waitForExistence(timeout: 5), "No product cards on Home")
        XCTAssertGreaterThanOrEqual(cards.count, 2, "Fewer than 2 cards")
        let a = cards.element(boundBy: 0).frame
        let b = cards.element(boundBy: 1).frame
        XCTAssertEqual(a.minY, b.minY, accuracy: 2, "Top two cards not on the same row")
        XCTAssertLessThan(a.width, window.width * 0.55, "Card too wide for a 2-col grid")
        XCTAssertLessThan(b.width, window.width * 0.55, "Card too wide for a 2-col grid")
    }

    // Red-line #5 — Catalog grid is 3 columns.
    func testCatalogGridIsThreeColumn() {
        openTab("Каталог")
        let cards = app.descendants(matching: .any).matching(identifier: "categoryCard")
        XCTAssertTrue(cards.firstMatch.waitForExistence(timeout: 5), "No category cards")
        XCTAssertGreaterThanOrEqual(cards.count, 3, "Fewer than 3 category cards")
        let a = cards.element(boundBy: 0).frame
        let b = cards.element(boundBy: 1).frame
        let c = cards.element(boundBy: 2).frame
        XCTAssertEqual(a.minY, b.minY, accuracy: 2, "Cards 0/1 not on the same row")
        XCTAssertEqual(b.minY, c.minY, accuracy: 2, "Cards 1/2 not on the same row")
        for f in [a, b, c] {
            XCTAssertLessThan(f.width, window.width * 0.38, "Card too wide for a 3-col grid")
        }
    }
}
