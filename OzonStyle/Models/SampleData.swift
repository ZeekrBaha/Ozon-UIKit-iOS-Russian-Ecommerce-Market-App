import Foundation

// Single source of truth for all mock content (red-line #7). Reached ONLY through
// SampleDataRepository — no view or view model references this enum directly.
enum SampleData {

    // MARK: Products

    static let watch = Product(
        imageName: "watch",
        imageCount: 6,
        isFavorite: true,
        badge: .salesOfWeek,
        installmentPrice: "1398 ₸",
        installmentTerm: "×12 мес",
        salePrice: "16 769 ₸",
        oldPrice: "154 967 ₸",
        discountPercent: 89,
        urgency: "218 шт осталось",
        title: "Смарт часы женские круглые, 2 ремешка, smart watch",
        rating: 4.7,
        reviewCount: 6,
        deliveryDate: "6 июня"
    )

    static let pedicure = Product(
        imageName: "pedicure",
        imageCount: 5,
        isFavorite: false,
        badge: nil,
        installmentPrice: "118 ₸",
        installmentTerm: "×12 мес",
        salePrice: "1405 ₸",
        oldPrice: nil,
        discountPercent: nil,
        urgency: nil,
        title: "Педикюрный инструмент для выпрямления вросших ногтей",
        rating: 4.7,
        reviewCount: 122,
        deliveryDate: "22 июня"
    )

    static let swimwear = Product(
        imageName: "swimwear",
        imageCount: 1,
        isFavorite: true,
        badge: nil,
        installmentPrice: "490 ₸",
        installmentTerm: "×12 мес",
        salePrice: "3 990 ₸",
        oldPrice: "7 990 ₸",
        discountPercent: 50,
        urgency: nil,
        title: "Купальник раздельный пуш-ап с высокой посадкой",
        rating: 4.7,
        reviewCount: 210,
        deliveryDate: "9 июня"
    )

    static let bikini = Product(
        imageName: "bikini",
        imageCount: 4,
        isFavorite: true,
        badge: nil,
        installmentPrice: "590 ₸",
        installmentTerm: "×12 мес",
        salePrice: "4 990 ₸",
        oldPrice: "9 990 ₸",
        discountPercent: 50,
        urgency: nil,
        title: "Купальник женский раздельный с цветочным принтом",
        rating: 4.8,
        reviewCount: 340,
        deliveryDate: "8 июня"
    )

    static let silverWatch = Product(
        imageName: "silverWatch",
        imageCount: 3,
        isFavorite: false,
        badge: nil,
        installmentPrice: "990 ₸",
        installmentTerm: "×12 мес",
        salePrice: "11 900 ₸",
        oldPrice: "23 800 ₸",
        discountPercent: 50,
        urgency: nil,
        title: "Часы наручные женские с браслетом, серебро",
        rating: 4.6,
        reviewCount: 88,
        deliveryDate: "10 июня"
    )

    static let wallet = Product(
        imageName: "wallet",
        imageCount: 2,
        isFavorite: false,
        badge: nil,
        installmentPrice: "320 ₸",
        installmentTerm: "×12 мес",
        salePrice: "3 200 ₸",
        oldPrice: nil,
        discountPercent: nil,
        urgency: nil,
        title: "Кошелёк женский кожаный клатч на молнии",
        rating: 4.5,
        reviewCount: 45,
        deliveryDate: "12 июня"
    )

    // MARK: Collections (reuse instances across screens)

    static let recommended: [Product] = [bikini, silverWatch, watch, wallet, swimwear, pedicure]
    static let viewed: [Product]      = [watch, pedicure, swimwear, bikini]

    // MARK: Categories (18, exact order — design.md Screen 2)

    static let categories: [Category] = [
        Category(title: "Женская одежда",        imageName: "cat_women"),
        Category(title: "Мужская одежда",        imageName: "cat_men"),
        Category(title: "Обувь",                 imageName: "cat_shoes"),
        Category(title: "Детская одежда",        imageName: "cat_kids"),
        Category(title: "Ювелирные украшения",   imageName: "cat_jewelry"),
        Category(title: "Электроника",           imageName: "cat_electronics"),
        Category(title: "Бытовая техника",       imageName: "cat_appliances"),
        Category(title: "Красота и здоровье",    imageName: "cat_beauty"),
        Category(title: "Дом и сад",             imageName: "cat_home"),
        Category(title: "Мебель",                imageName: "cat_furniture"),
        Category(title: "Аксессуары",            imageName: "cat_accessories"),
        Category(title: "Строительство и ремонт", imageName: "cat_tools"),
        Category(title: "Автотовары",            imageName: "cat_auto"),
        Category(title: "Продукты питания",      imageName: "cat_food"),
        Category(title: "Товары для животных",   imageName: "cat_pets"),
        Category(title: "Детские товары",        imageName: "cat_baby"),
        Category(title: "Спорт и отдых",         imageName: "cat_sport"),
        Category(title: "Книги",                 imageName: "cat_books")
    ]

    // MARK: Carousel banners (Home, 4 slides — auto-advancing)

    static let banners: [Banner] = [
        Banner(imageName: "banner_computers"),
        Banner(imageName: "banner_cosmetics"),
        Banner(imageName: "banner_gadgets"),
        Banner(imageName: "banner_home")
    ]

    // MARK: Quick actions (6, exact order — design.md Screen 1)

    static let quickActions: [QuickAction] = [
        QuickAction(title: "Каталог",             imageName: "qa_catalog"),
        QuickAction(title: "Быстрая доставка",    imageName: "qa_fast"),
        QuickAction(title: "Рассрочка 0-0-12",    imageName: "qa_installment"),
        QuickAction(title: "Сделано в Казахстане", imageName: "qa_kz"),
        QuickAction(title: "Ozon Селект",         imageName: "qa_select"),
        QuickAction(title: "Товары из Китая",     imageName: "qa_china")
    ]

    // MARK: Settings (5 — design.md Screen 5)

    static let settings: [SettingsItem] = [
        SettingsItem(title: "Валюта",          value: "KZT"),
        SettingsItem(title: "Цвет приложения", value: nil),
        SettingsItem(title: "Язык",            value: nil),
        SettingsItem(title: "Помощь",          value: nil),
        SettingsItem(title: "О приложении",    value: nil)
    ]
}
