import XCTest

// End-to-end UI coverage: the 5-tab structure, each screen's content marker, and
// the product → detail → back navigation flow driven by the coordinators.
final class OzonStyleUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    private func openTab(_ label: String) {
        let tab = app.tabBars.buttons[label]
        XCTAssertTrue(tab.waitForExistence(timeout: 5), "Tab \"\(label)\" not found")
        tab.tap()
    }

    private func assertText(_ text: String, _ message: String) {
        XCTAssertTrue(app.staticTexts[text].waitForExistence(timeout: 5), message)
    }

    // Matches by accessibility label across any element type — for content that is
    // wrapped in a single a11y element (categoryCard / cartEmptyBand) rather than a
    // standalone staticText.
    private func assertLabel(_ text: String, _ message: String) {
        let el = app.descendants(matching: .any).matching(NSPredicate(format: "label == %@", text)).firstMatch
        XCTAssertTrue(el.waitForExistence(timeout: 5), message)
    }

    // Scroll a product card into view, then tap it.
    private func tapFirstProductCard() {
        let card = app.buttons.matching(identifier: "productCard").firstMatch
        XCTAssertTrue(card.waitForExistence(timeout: 5), "No product card")
        var tries = 0
        while !card.isHittable && tries < 6 { app.swipeUp(); tries += 1 }
        card.tap()
    }

    // MARK: Structure

    func testTabBarHasFiveTabs() {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5), "Tab bar missing")
        for label in ["Главная", "Каталог", "Избранное", "Корзина", "Мой Ozon"] {
            XCTAssertTrue(tabBar.buttons[label].exists, "Missing tab: \(label)")
        }
    }

    // MARK: Per-screen content (launch lands on Home)

    func testHomeScreen() {
        assertText("Рекомендуем", "Home recommended section missing")
    }

    func testCatalogScreen() {
        openTab("Каталог")
        assertLabel("Электроника", "Catalog category grid missing")
    }

    func testFavoritesScreen() {
        openTab("Избранное")
        assertText("Подобрали для вас", "Favorites section header missing")
    }

    func testCartScreen() {
        openTab("Корзина")
        assertLabel("Корзина пуста", "Cart empty-state band missing")
    }

    func testProfileScreen() {
        openTab("Мой Ozon")
        assertText("Войдите в личный кабинет", "Profile CTA missing")
    }

    // MARK: Navigation flow — product → detail → back

    func testProductDetailNavigationFromHome() {
        tapFirstProductCard()
        let detailBar = app.navigationBars["Товар"]
        XCTAssertTrue(detailBar.waitForExistence(timeout: 5), "Product detail did not push")

        detailBar.buttons.firstMatch.tap() // back
        XCTAssertTrue(app.staticTexts["Рекомендуем"].waitForExistence(timeout: 5),
                      "Did not return to Home after back")
        XCTAssertFalse(app.navigationBars["Товар"].exists, "Detail still on screen after back")
    }

    func testProductDetailNavigationFromCart() {
        openTab("Корзина")
        tapFirstProductCard()
        XCTAssertTrue(app.navigationBars["Товар"].waitForExistence(timeout: 5),
                      "Cart tab did not push product detail")
    }
}
