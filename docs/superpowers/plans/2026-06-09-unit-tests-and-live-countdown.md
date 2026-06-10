# Unit Tests + Live Countdown + Safety Fixes Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a unit test target with ViewModel coverage, replace the static sale countdown with a live ticking timer (TDD), remove the force cast crash risk, and tokenize magic numbers in the banner carousel.

**Architecture:** Existing MVVM-C stays untouched. New `OzonStyleTests` unit-test bundle (XCTest, TEST_HOST = OzonStyle.app) is added by hand-editing `project.pbxproj` and the shared scheme. Countdown logic lives in `HomeViewModel` (pure, no UIKit) as a `@Published` string driven by a Combine timer; `HomeViewController` binds a label to it.

**Tech Stack:** Swift 5, UIKit, Combine, XCTest. No third-party deps. Build/test via `xcodebuild` against booted simulator `iPhone 15 Pro Max` (id `9CD022E7-8D61-4B78-A4EC-5E6D66EEF156`).

**Out of scope (separate plan):** Localization extraction (`Localizable.strings`) — large mechanical sweep, independent subsystem.

**Working branch:** `fix/unit-tests-and-countdown` off `main`.

**Test command (used throughout):**
```bash
cd /Users/baha/Desktop/llm-ai-projects/Ozon-UIKit-iOS-Russian-Ecommerce-Market-App
xcodebuild test -project OzonStyle.xcodeproj -scheme OzonStyle \
  -destination 'platform=iOS Simulator,id=9CD022E7-8D61-4B78-A4EC-5E6D66EEF156' \
  -only-testing:OzonStyleTests 2>&1 | tail -20
```

---

### Task 1: Unit test target infrastructure (pbxproj + scheme + smoke test)

**Files:**
- Create: `OzonStyleTests/HomeViewModelTests.swift`
- Modify: `OzonStyle.xcodeproj/project.pbxproj`
- Modify: `OzonStyle.xcodeproj/xcshareddata/xcschemes/OzonStyle.xcscheme`

New pbxproj object IDs (24-hex, unique in file):
| ID | Object |
|---|---|
| `1000000000000000000000A1` | PBXFileReference HomeViewModelTests.swift |
| `1000000000000000000000A2` | PBXBuildFile HomeViewModelTests.swift in Sources |
| `1000000000000000000000A3` | PBXGroup OzonStyleTests |
| `1000000000000000000000A4` | PBXNativeTarget OzonStyleTests |
| `1000000000000000000000A5` | PBXFileReference OzonStyleTests.xctest |
| `1000000000000000000000A6` | PBXSourcesBuildPhase |
| `1000000000000000000000A7` | XCConfigurationList |
| `1000000000000000000000A8` | XCBuildConfiguration Debug |
| `1000000000000000000000A9` | XCBuildConfiguration Release |
| `1000000000000000000000AA` | PBXTargetDependency |
| `1000000000000000000000AB` | PBXContainerItemProxy |

- [ ] **Step 1: Create branch**

```bash
git checkout -b fix/unit-tests-and-countdown
```

- [ ] **Step 2: Write the smoke test file (will fail to run — target doesn't exist yet)**

Create `OzonStyleTests/HomeViewModelTests.swift`:

```swift
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
    func categories() -> [Category] { [] }
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
}
```

- [ ] **Step 3: Run test — verify it fails for the right reason (no such target)**

Run: test command with `-only-testing:OzonStyleTests`
Expected: FAIL — `xcodebuild: error: ... does not contain a test target named 'OzonStyleTests'` (or scheme error). Confirms target missing, not a typo.

- [ ] **Step 4: Add target to project.pbxproj (7 edits)**

4a. In `PBXBuildFile` section, after the `047EF5808D982481A1773E4B` line, add:
```
		1000000000000000000000A2 /* HomeViewModelTests.swift in Sources */ = {isa = PBXBuildFile; fileRef = 1000000000000000000000A1 /* HomeViewModelTests.swift */; };
```

4b. In `PBXContainerItemProxy` section, after the existing proxy block, add:
```
		1000000000000000000000AB /* PBXContainerItemProxy */ = {
			isa = PBXContainerItemProxy;
			containerPortal = 017DB26B058E30C4F10695CF /* Project object */;
			proxyType = 1;
			remoteGlobalIDString = 237ECF4B3A6FB39D9A349673;
			remoteInfo = OzonStyle;
		};
```

4c. In `PBXFileReference` section, add (two entries):
```
		1000000000000000000000A1 /* HomeViewModelTests.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = HomeViewModelTests.swift; sourceTree = "<group>"; };
		1000000000000000000000A5 /* OzonStyleTests.xctest */ = {isa = PBXFileReference; includeInIndex = 0; lastKnownFileType = wrapper.cfbundle; path = OzonStyleTests.xctest; sourceTree = BUILT_PRODUCTS_DIR; };
```

4d. In `PBXGroup` section add the group, and register it in main group `CB0AB8DA65F15B7C01489F0B` children (after `41AAE1DAFDFE8EDCE8C8F1B4 /* OzonStyleUITests */`) plus product in `99056EFFBC4139B56F901399 /* Products */` children:
```
		1000000000000000000000A3 /* OzonStyleTests */ = {
			isa = PBXGroup;
			children = (
				1000000000000000000000A1 /* HomeViewModelTests.swift */,
			);
			path = OzonStyleTests;
			sourceTree = "<group>";
		};
```

4e. In `PBXNativeTarget` section, add:
```
		1000000000000000000000A4 /* OzonStyleTests */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = 1000000000000000000000A7 /* Build configuration list for PBXNativeTarget "OzonStyleTests" */;
			buildPhases = (
				1000000000000000000000A6 /* Sources */,
			);
			buildRules = (
			);
			dependencies = (
				1000000000000000000000AA /* PBXTargetDependency */,
			);
			name = OzonStyleTests;
			packageProductDependencies = (
			);
			productName = OzonStyleTests;
			productReference = 1000000000000000000000A5 /* OzonStyleTests.xctest */;
			productType = "com.apple.product-type.bundle.unit-test";
		};
```

4f. In `PBXProject`: add to `TargetAttributes`:
```
					1000000000000000000000A4 = {
						DevelopmentTeam = "";
						TestTargetID = 237ECF4B3A6FB39D9A349673;
					};
```
and to `targets = (` list:
```
				1000000000000000000000A4 /* OzonStyleTests */,
```

4g. Add Sources phase, dependency, configs, config list:
```
		1000000000000000000000A6 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				1000000000000000000000A2 /* HomeViewModelTests.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
```
(in PBXTargetDependency section:)
```
		1000000000000000000000AA /* PBXTargetDependency */ = {
			isa = PBXTargetDependency;
			target = 237ECF4B3A6FB39D9A349673 /* OzonStyle */;
			targetProxy = 1000000000000000000000AB /* PBXContainerItemProxy */;
		};
```
(in XCBuildConfiguration section:)
```
		1000000000000000000000A8 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				BUNDLE_LOADER = "$(TEST_HOST)";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
					"@loader_path/Frameworks",
				);
				PRODUCT_BUNDLE_IDENTIFIER = com.baha.OzonStyleTests;
				SDKROOT = iphoneos;
				TARGETED_DEVICE_FAMILY = "1,2";
				TEST_HOST = "$(BUILT_PRODUCTS_DIR)/OzonStyle.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/OzonStyle";
			};
			name = Debug;
		};
		1000000000000000000000A9 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				BUNDLE_LOADER = "$(TEST_HOST)";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
					"@loader_path/Frameworks",
				);
				PRODUCT_BUNDLE_IDENTIFIER = com.baha.OzonStyleTests;
				SDKROOT = iphoneos;
				TARGETED_DEVICE_FAMILY = "1,2";
				TEST_HOST = "$(BUILT_PRODUCTS_DIR)/OzonStyle.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/OzonStyle";
			};
			name = Release;
		};
```
(in XCConfigurationList section:)
```
		1000000000000000000000A7 /* Build configuration list for PBXNativeTarget "OzonStyleTests" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				1000000000000000000000A8 /* Debug */,
				1000000000000000000000A9 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Debug;
		};
```

- [ ] **Step 5: Add testable to scheme**

In `OzonStyle.xcscheme` `<Testables>`, BEFORE the existing UITests `<TestableReference>`, add:
```xml
         <TestableReference
            skipped = "NO">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "1000000000000000000000A4"
               BuildableName = "OzonStyleTests.xctest"
               BlueprintName = "OzonStyleTests"
               ReferencedContainer = "container:OzonStyle.xcodeproj">
            </BuildableReference>
         </TestableReference>
```

- [ ] **Step 6: Run unit tests — verify pass**

Run: test command.
Expected: `Test Suite 'HomeViewModelTests' passed` / `** TEST SUCCEEDED **`, 1 test.

- [ ] **Step 7: Commit**

```bash
git add OzonStyleTests OzonStyle.xcodeproj
git commit -m "test: add OzonStyleTests unit test target with first HomeViewModel test"
```

---

### Task 2: HomeViewModel characterization tests (banner carousel behavior)

These document EXISTING behavior — they must pass immediately. Any failure = found bug, stop and investigate.

**Files:**
- Modify: `OzonStyleTests/HomeViewModelTests.swift`

- [ ] **Step 1: Add tests inside `HomeViewModelTests`**

```swift
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
```

- [ ] **Step 2: Run unit tests**

Run: test command. Expected: PASS, 5 tests.

- [ ] **Step 3: Commit**

```bash
git add OzonStyleTests/HomeViewModelTests.swift
git commit -m "test: characterize HomeViewModel banner index behavior"
```

---

### Task 3: Remove force cast in BannerCarouselView

**Files:**
- Modify: `OzonStyle/Components/BannerCarouselView.swift:60-64`

- [ ] **Step 1: Replace force cast with guarded dequeue**

Old:
```swift
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.reuseID, for: indexPath) as! BannerCell
        cell.configure(named: banners[indexPath.item].imageName)
        return cell
    }
```
New:
```swift
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BannerCell.reuseID, for: indexPath) as? BannerCell else {
            assertionFailure("BannerCell is not registered for \(BannerCell.reuseID)")
            return UICollectionViewCell()
        }
        cell.configure(named: banners[indexPath.item].imageName)
        return cell
    }
```

- [ ] **Step 2: Build + run unit tests (compile gate)**

Run: test command. Expected: PASS.

- [ ] **Step 3: Commit**

```bash
git add OzonStyle/Components/BannerCarouselView.swift
git commit -m "fix: replace force cast with guarded dequeue in BannerCarouselView"
```

---

### Task 4: Live sale countdown in HomeViewModel (TDD — RED first)

19:45:13 = 71113 seconds (default seed matching design).

**Files:**
- Modify: `OzonStyleTests/HomeViewModelTests.swift`
- Modify: `OzonStyle/ViewModels/HomeViewModel.swift`

- [ ] **Step 1: Write failing tests**

Add to `HomeViewModelTests`:
```swift
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
```

- [ ] **Step 2: Run — verify FAIL for right reason**

Run: test command.
Expected: COMPILE ERROR — `type 'HomeViewModel' has no member 'countdownText'`, no `saleSecondsRemaining:` init param. (Compile failure = RED for new API.)

- [ ] **Step 3: Minimal implementation in HomeViewModel.swift**

```swift
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

    // ... startCarousel/stopCarousel/advanceBanner/syncBannerIndex unchanged ...

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
```

- [ ] **Step 4: Run — verify PASS (10 tests)**

- [ ] **Step 5: Commit**

```bash
git add OzonStyleTests/HomeViewModelTests.swift OzonStyle/ViewModels/HomeViewModel.swift
git commit -m "feat: live sale countdown state in HomeViewModel (TDD)"
```

---

### Task 5: Bind countdown label in HomeViewController

**Files:**
- Modify: `OzonStyle/Screens/HomeViewController.swift`

- [ ] **Step 1: Replace static label, bind to ViewModel, start/stop with lifecycle**

In `makeHeroRow()` replace:
```swift
        let countdown = DarkPillView(UI.hStack([
            UI.label("19:45:13 до старта", .systemFont(ofSize: 14, weight: .semibold), .white),
            UI.symbol("chevron.right", .white, size: 12, weight: .semibold),
        ], spacing: 8), height: 36, hPadding: 14)
```
with:
```swift
        let countdownLabel = UI.label("\(viewModel.saleCountdownText) до старта",
                                      .systemFont(ofSize: 14, weight: .semibold), .white)
        self.countdownLabel = countdownLabel
        let countdown = DarkPillView(UI.hStack([
            countdownLabel,
            UI.symbol("chevron.right", .white, size: 12, weight: .semibold),
        ], spacing: 8), height: 36, hPadding: 14)
```

Add property next to `private var carousel: BannerCarouselView?`:
```swift
    private var countdownLabel: UILabel?
```

Add binding in `viewDidLoad()` after the `$bannerIndex` sink:
```swift
        viewModel.$saleCountdownText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in self?.countdownLabel?.text = "\(text) до старта" }
            .store(in: &cancellables)
```

Lifecycle: in `viewWillAppear` add `viewModel.startSaleCountdown()`; in `viewWillDisappear` add `viewModel.stopSaleCountdown()`.

- [ ] **Step 2: Run unit tests (compile + regression gate)**

Run: test command. Expected: PASS, 10 tests.

- [ ] **Step 3: Commit**

```bash
git add OzonStyle/Screens/HomeViewController.swift
git commit -m "feat: bind hero countdown pill to live HomeViewModel countdown"
```

---

### Task 6: Tokenize banner carousel magic numbers

**Files:**
- Modify: `OzonStyle/DesignSystem/Layout.swift`
- Modify: `OzonStyle/Components/BannerCarouselView.swift:28,41`

- [ ] **Step 1: Add tokens to Layout enum (after `cornerSheet`)**

```swift
    static let cornerBanner: CGFloat   = 16   // home promo carousel
    static let bannerHeight: CGFloat   = 150  // home promo carousel
```

- [ ] **Step 2: Use them in BannerCarouselView**

`layer.cornerRadius = 16` → `layer.cornerRadius = Layout.cornerBanner`
`heightAnchor.constraint(equalToConstant: 150)` → `heightAnchor.constraint(equalToConstant: Layout.bannerHeight)`

- [ ] **Step 3: Run unit tests (compile gate)** — Expected: PASS.

- [ ] **Step 4: Commit**

```bash
git add OzonStyle/DesignSystem/Layout.swift OzonStyle/Components/BannerCarouselView.swift
git commit -m "refactor: replace banner carousel magic numbers with Layout tokens"
```

---

### Task 7: Full verification (unit + UI tests)

- [ ] **Step 1: Run FULL suite (unit + UI)**

```bash
xcodebuild test -project OzonStyle.xcodeproj -scheme OzonStyle \
  -destination 'platform=iOS Simulator,id=9CD022E7-8D61-4B78-A4EC-5E6D66EEF156' 2>&1 | tail -30
```
Expected: `** TEST SUCCEEDED **` — 10 unit tests + existing UI tests green. UI tests assert static text on Home; countdown pill text now changes per second but no UI test asserts the literal "19:45:13 до старта" string — if one does, update it to assert by prefix/suffix "до старта".

- [ ] **Step 2: Report counts, stop**

No push/merge without user say-so.
