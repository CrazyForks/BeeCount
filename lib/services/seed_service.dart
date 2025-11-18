import '../data/db.dart';
import '../l10n/app_localizations.dart';
import 'logger_service.dart';
import 'package:drift/drift.dart';

/// 种子数据服务
/// 负责生成应用初始化时的默认数据（账本、账户、分类等）
class SeedService {
  SeedService._();

  // ========== 一级分类模式的默认分类 key ==========

  /// 默认支出分类 key 列表（一级分类模式）
  static const List<String> flatExpenseCategoryKeys = [
    'dining', 'transport', 'shopping', 'entertainment', 'home', 'family',
    'communication', 'utilities', 'housing', 'medical', 'education',
    'pets', 'sports', 'digital', 'travel', 'alcohol_tobacco', 'baby_care',
    'beauty', 'repair', 'social', 'learning', 'car', 'taxi', 'subway',
    'delivery', 'property', 'parking', 'donation', 'gift', 'tax',
    'beverage', 'clothing', 'snacks', 'red_packet', 'fruit', 'game',
    'book', 'lover', 'decoration', 'daily_goods', 'lottery', 'stock',
    'social_security', 'express', 'work'
  ];

  /// 默认收入分类 key 列表（一级分类模式）
  static const List<String> flatIncomeCategoryKeys = [
    'salary', 'investment', 'red_packet', 'bonus', 'reimbursement',
    'part_time', 'gift', 'interest', 'refund', 'invest_income',
    'second_hand', 'social_benefit', 'tax_refund', 'provident_fund'
  ];

  // ========== 二级分类模式的默认分类（父分类 -> 子分类列表）==========

  /// 二级分类模式的默认支出分类
  static const Map<String, List<String>> hierarchicalExpenseCategories = {
    'dining': ['dining_breakfast', 'dining_lunch', 'dining_dinner', 'dining_meituan', 'dining_eleme', 'dining_jd', 'dining_restaurant', 'dining_food'],
    'snacks': ['snacks_biscuit', 'snacks_chips', 'snacks_candy', 'snacks_chocolate', 'snacks_nuts'],
    'fruit': ['fruit_apple', 'fruit_banana', 'fruit_orange', 'fruit_grape', 'fruit_watermelon', 'fruit_other'],
    'beverage': ['beverage_milk_tea', 'beverage_coffee', 'beverage_juice', 'beverage_soda', 'beverage_water'],
    'pastry': ['pastry_cake', 'pastry_bread', 'pastry_dessert', 'pastry_biscuit'],
    'cooking': ['cooking_vegetable', 'cooking_meat', 'cooking_seafood', 'cooking_seasoning', 'cooking_grain'],
    'shopping': ['shopping_clothing', 'shopping_shoes', 'shopping_bag', 'shopping_accessory', 'shopping_daily'],
    'pets': ['pets_food', 'pets_supplies', 'pets_medical', 'pets_grooming'],
    'transport': ['transport_subway', 'transport_bus', 'transport_taxi', 'transport_ride', 'transport_parking', 'transport_fuel'],
    'car': ['car_maintenance', 'car_repair', 'car_insurance', 'car_wash', 'car_fine'],
    'clothing': ['clothing_top', 'clothing_pants', 'clothing_skirt', 'clothing_shoes', 'clothing_accessory'],
    'daily_goods': ['daily_toiletries', 'daily_paper', 'daily_cleaning', 'daily_kitchen'],
    'education': ['education_tuition', 'education_training', 'education_books', 'education_stationery', 'education_office'],
    'invest_loss': ['invest_loss_stock', 'invest_loss_fund', 'invest_loss_other'],
    'entertainment': ['entertainment_movie', 'entertainment_ktv', 'entertainment_amusement', 'entertainment_bar', 'entertainment_other'],
    'game': ['game_recharge', 'game_equipment', 'game_membership'],
    'health_products': ['health_vitamin', 'health_food', 'health_nutrition'],
    'subscription': ['subscription_video', 'subscription_music', 'subscription_cloud', 'subscription_other'],
    'sports': ['sports_gym', 'sports_equipment', 'sports_course', 'sports_outdoor'],
    'housing': ['housing_rent', 'housing_property', 'housing_mortgage', 'housing_decoration'],
    'home': ['home_furniture', 'home_appliance', 'home_decor', 'home_bedding'],
    'beauty': ['beauty_skincare', 'beauty_cosmetics', 'beauty_salon', 'beauty_nail'],
  };

  /// 二级分类模式的默认收入分类
  static const Map<String, List<String>> hierarchicalIncomeCategories = {
    'salary': ['salary_basic', 'salary_performance', 'salary_year_end', 'salary_overtime'],
    'investment': ['investment_fund', 'investment_dividend', 'investment_product', 'investment_other'],
    'red_packet': ['red_packet_festival', 'red_packet_birthday', 'red_packet_return'],
    'bonus': ['bonus_year_end', 'bonus_quarterly', 'bonus_project', 'bonus_other'],
    'reimbursement': ['reimbursement_travel', 'reimbursement_meal', 'reimbursement_other'],
    'part_time': ['part_time_income', 'part_time_extra'],
    'gift': ['gift_wedding', 'gift_birthday', 'gift_other'],
    'interest': ['interest_bank', 'interest_other'],
    'refund': ['refund_shopping', 'refund_service', 'refund_other'],
    'invest_income': ['invest_income_stock', 'invest_income_fund', 'invest_income_other'],
    'second_hand': ['second_hand_idle', 'second_hand_goods'],
    'social_benefit': ['social_benefit_unemployment', 'social_benefit_maternity', 'social_benefit_other'],
    'tax_refund': ['tax_refund_personal', 'tax_refund_other'],
    'provident_fund': ['provident_fund_withdrawal', 'provident_fund_interest'],
  };

  // ========== 分类图标映射 ==========

  /// 获取分类的默认图标
  /// 注意：这里只提供默认图标，不做名称匹配
  static String getDefaultIcon(String categoryKey) {
    // 支出分类图标
    const expenseIcons = {
      'dining': 'restaurant',
      'transport': 'directions_car',
      'shopping': 'shopping_cart',
      'entertainment': 'movie',
      'home': 'home',
      'family': 'family_restroom',
      'communication': 'phone',
      'utilities': 'flash_on',
      'housing': 'home_work',
      'medical': 'local_hospital',
      'education': 'school',
      'pets': 'pets',
      'sports': 'fitness_center',
      'digital': 'smartphone',
      'travel': 'flight',
      'alcohol_tobacco': 'local_bar',
      'baby_care': 'child_care',
      'beauty': 'face',
      'repair': 'handyman',
      'social': 'group',
      'learning': 'school',
      'car': 'directions_car',
      'taxi': 'local_taxi',
      'subway': 'directions_subway',
      'delivery': 'delivery_dining',
      'property': 'apartment',
      'parking': 'local_parking',
      'donation': 'volunteer_activism',
      'gift': 'card_giftcard',
      'tax': 'receipt_long',
      'beverage': 'local_cafe',
      'clothing': 'checkroom',
      'snacks': 'fastfood',
      'red_packet': 'wallet',
      'fruit': 'eco',
      'game': 'sports_esports',
      'book': 'menu_book',
      'lover': 'favorite',
      'decoration': 'home_repair_service',
      'daily_goods': 'local_laundry_service',
      'lottery': 'confirmation_number',
      'stock': 'trending_up',
      'social_security': 'security',
      'express': 'local_shipping',
      'work': 'work_outline',
      // 二级分类
      'snacks_biscuit': 'fastfood',
      'snacks_chips': 'fastfood',
      'snacks_candy': 'fastfood',
      'snacks_chocolate': 'fastfood',
      'snacks_nuts': 'fastfood',
      'fruit_apple': 'eco',
      'fruit_banana': 'eco',
      'fruit_orange': 'eco',
      'fruit_grape': 'eco',
      'fruit_watermelon': 'eco',
      'fruit_other': 'eco',
      'beverage_milk_tea': 'local_cafe',
      'beverage_coffee': 'local_cafe',
      'beverage_juice': 'local_cafe',
      'beverage_soda': 'local_cafe',
      'beverage_water': 'local_cafe',
      'pastry_cake': 'cake',
      'pastry_bread': 'bakery_dining',
      'pastry_dessert': 'cake',
      'pastry_biscuit': 'fastfood',
      'cooking_vegetable': 'local_grocery_store',
      'cooking_meat': 'local_grocery_store',
      'cooking_seafood': 'local_grocery_store',
      'cooking_seasoning': 'local_grocery_store',
      'cooking_grain': 'local_grocery_store',
    };

    // 收入分类图标
    const incomeIcons = {
      'salary': 'work',
      'investment': 'account_balance',
      'bonus': 'emoji_events',
      'reimbursement': 'receipt',
      'part_time': 'schedule',
      'interest': 'monetization_on',
      'refund': 'undo',
      'invest_income': 'trending_up',
      'second_hand': 'sell',
      'social_benefit': 'health_and_safety',
      'tax_refund': 'receipt_long',
      'provident_fund': 'account_balance_wallet',
    };

    return expenseIcons[categoryKey] ?? incomeIcons[categoryKey] ?? 'category';
  }

  // ========== 种子数据生成方法 ==========

  /// 生成默认账本
  static Future<int> createDefaultLedger(
    BeeDatabase db,
    AppLocalizations l10n,
    String currency,
  ) async {
    final ledgerId = await db.into(db.ledgers).insert(
      LedgersCompanion.insert(
        name: l10n.ledgerDefaultName,
        currency: Value(currency),
      ),
    );
    return ledgerId;
  }

  /// 生成默认账户（3个：现金、银行卡、信用卡）
  static Future<void> createDefaultAccounts(
    BeeDatabase db,
    int ledgerId,
    AppLocalizations l10n,
    String currency,
  ) async {
    // 1. 现金账户
    await db.into(db.accounts).insert(
      AccountsCompanion.insert(
        ledgerId: ledgerId,
        name: l10n.accountTypeCash,
        type: const Value('cash'),
        currency: Value(currency),
        initialBalance: const Value(0.0),
      ),
    );

    // 2. 银行卡账户
    await db.into(db.accounts).insert(
      AccountsCompanion.insert(
        ledgerId: ledgerId,
        name: l10n.accountTypeBankCard,
        type: const Value('bank_card'),
        currency: Value(currency),
        initialBalance: const Value(0.0),
      ),
    );

    // 3. 信用卡账户
    await db.into(db.accounts).insert(
      AccountsCompanion.insert(
        ledgerId: ledgerId,
        name: l10n.accountTypeCreditCard,
        type: const Value('credit_card'),
        currency: Value(currency),
        initialBalance: const Value(0.0),
      ),
    );
  }

  /// 获取翻译后的分类名称（用于一级分类模式）
  static String _getTranslatedCategoryName(
    String key,
    String kind,
    AppLocalizations l10n,
  ) {
    final translationString = kind == 'expense' ? l10n.categoryExpenseList : l10n.categoryIncomeList;
    final names = translationString.split('-');
    final keys = kind == 'expense' ? flatExpenseCategoryKeys : flatIncomeCategoryKeys;

    final index = keys.indexOf(key);
    if (index >= 0 && index < names.length) {
      return names[index].trim();
    }

    return key; // fallback
  }

  /// 获取翻译后的父分类名称（用于二级分类模式）
  static String _getTranslatedParentCategoryName(
    String key,
    String kind,
    AppLocalizations l10n,
  ) {
    if (kind == 'expense') {
      switch (key) {
        case 'dining': return l10n.categoryExpenseDining.split('-')[0].trim();
        case 'snacks': return l10n.categoryExpenseSnacks.split('-')[0].trim();
        case 'fruit': return l10n.categoryExpenseFruit.split('-')[0].trim();
        case 'beverage': return l10n.categoryExpenseBeverage.split('-')[0].trim();
        case 'pastry': return l10n.categoryExpensePastry.split('-')[0].trim();
        case 'cooking': return l10n.categoryExpenseCooking.split('-')[0].trim();
        case 'shopping': return l10n.categoryExpenseShopping.split('-')[0].trim();
        case 'pets': return l10n.categoryExpensePets.split('-')[0].trim();
        case 'transport': return l10n.categoryExpenseTransport.split('-')[0].trim();
        case 'car': return l10n.categoryExpenseCar.split('-')[0].trim();
        case 'clothing': return l10n.categoryExpenseClothing.split('-')[0].trim();
        case 'daily_goods': return l10n.categoryExpenseDailyGoods.split('-')[0].trim();
        case 'education': return l10n.categoryExpenseEducation.split('-')[0].trim();
        case 'invest_loss': return l10n.categoryExpenseInvestLoss.split('-')[0].trim();
        case 'entertainment': return l10n.categoryExpenseEntertainment.split('-')[0].trim();
        case 'game': return l10n.categoryExpenseGame.split('-')[0].trim();
        case 'health_products': return l10n.categoryExpenseHealthProducts.split('-')[0].trim();
        case 'subscription': return l10n.categoryExpenseSubscription.split('-')[0].trim();
        case 'sports': return l10n.categoryExpenseSports.split('-')[0].trim();
        case 'housing': return l10n.categoryExpenseHousing.split('-')[0].trim();
        case 'home': return l10n.categoryExpenseHome.split('-')[0].trim();
        case 'beauty': return l10n.categoryExpenseBeauty.split('-')[0].trim();
        default: return key;
      }
    } else {
      switch (key) {
        case 'salary': return l10n.categoryIncomeSalary.split('-')[0].trim();
        case 'investment': return l10n.categoryIncomeInvestment.split('-')[0].trim();
        case 'red_packet': return l10n.categoryIncomeRedPacket.split('-')[0].trim();
        case 'bonus': return l10n.categoryIncomeBonus.split('-')[0].trim();
        case 'reimbursement': return l10n.categoryIncomeReimbursement.split('-')[0].trim();
        case 'part_time': return l10n.categoryIncomePartTime.split('-')[0].trim();
        case 'gift': return l10n.categoryIncomeGift.split('-')[0].trim();
        case 'interest': return l10n.categoryIncomeInterest.split('-')[0].trim();
        case 'refund': return l10n.categoryIncomeRefund.split('-')[0].trim();
        case 'invest_income': return l10n.categoryIncomeInvestIncome.split('-')[0].trim();
        case 'second_hand': return l10n.categoryIncomeSecondHand.split('-')[0].trim();
        case 'social_benefit': return l10n.categoryIncomeSocialBenefit.split('-')[0].trim();
        case 'tax_refund': return l10n.categoryIncomeTaxRefund.split('-')[0].trim();
        case 'provident_fund': return l10n.categoryIncomeProvidentFund.split('-')[0].trim();
        default: return key;
      }
    }
  }

  /// 获取翻译后的子分类名称
  static String _getTranslatedSubCategoryName(
    String key,
    String kind,
    AppLocalizations l10n,
  ) {
    // 从父分类列表中查找包含此子分类的父分类
    final categoryMap = kind == 'expense'
        ? hierarchicalExpenseCategories
        : hierarchicalIncomeCategories;

    String? parentKey;
    for (final entry in categoryMap.entries) {
      if (entry.value.contains(key)) {
        parentKey = entry.key;
        break;
      }
    }

    if (parentKey == null) return key;

    // 获取父分类的翻译字符串
    String translationString;
    if (kind == 'expense') {
      switch (parentKey) {
        case 'dining': translationString = l10n.categoryExpenseDining; break;
        case 'snacks': translationString = l10n.categoryExpenseSnacks; break;
        case 'fruit': translationString = l10n.categoryExpenseFruit; break;
        case 'beverage': translationString = l10n.categoryExpenseBeverage; break;
        case 'pastry': translationString = l10n.categoryExpensePastry; break;
        case 'cooking': translationString = l10n.categoryExpenseCooking; break;
        case 'shopping': translationString = l10n.categoryExpenseShopping; break;
        case 'pets': translationString = l10n.categoryExpensePets; break;
        case 'transport': translationString = l10n.categoryExpenseTransport; break;
        case 'car': translationString = l10n.categoryExpenseCar; break;
        case 'clothing': translationString = l10n.categoryExpenseClothing; break;
        case 'daily_goods': translationString = l10n.categoryExpenseDailyGoods; break;
        case 'education': translationString = l10n.categoryExpenseEducation; break;
        case 'invest_loss': translationString = l10n.categoryExpenseInvestLoss; break;
        case 'entertainment': translationString = l10n.categoryExpenseEntertainment; break;
        case 'game': translationString = l10n.categoryExpenseGame; break;
        case 'health_products': translationString = l10n.categoryExpenseHealthProducts; break;
        case 'subscription': translationString = l10n.categoryExpenseSubscription; break;
        case 'sports': translationString = l10n.categoryExpenseSports; break;
        case 'housing': translationString = l10n.categoryExpenseHousing; break;
        case 'home': translationString = l10n.categoryExpenseHome; break;
        case 'beauty': translationString = l10n.categoryExpenseBeauty; break;
        default: return key;
      }
    } else {
      switch (parentKey) {
        case 'salary': translationString = l10n.categoryIncomeSalary; break;
        case 'investment': translationString = l10n.categoryIncomeInvestment; break;
        case 'red_packet': translationString = l10n.categoryIncomeRedPacket; break;
        case 'bonus': translationString = l10n.categoryIncomeBonus; break;
        case 'reimbursement': translationString = l10n.categoryIncomeReimbursement; break;
        case 'part_time': translationString = l10n.categoryIncomePartTime; break;
        case 'gift': translationString = l10n.categoryIncomeGift; break;
        case 'interest': translationString = l10n.categoryIncomeInterest; break;
        case 'refund': translationString = l10n.categoryIncomeRefund; break;
        case 'invest_income': translationString = l10n.categoryIncomeInvestIncome; break;
        case 'second_hand': translationString = l10n.categoryIncomeSecondHand; break;
        case 'social_benefit': translationString = l10n.categoryIncomeSocialBenefit; break;
        case 'tax_refund': translationString = l10n.categoryIncomeTaxRefund; break;
        case 'provident_fund': translationString = l10n.categoryIncomeProvidentFund; break;
        default: return key;
      }
    }

    final names = translationString.split('-');
    final childKeys = kind == 'expense'
        ? (hierarchicalExpenseCategories[parentKey] ?? [])
        : (hierarchicalIncomeCategories[parentKey] ?? []);

    final index = childKeys.indexOf(key);
    if (index >= 0 && index < names.length) {
      return names[index].trim();
    }

    return key; // fallback
  }

  /// 生成默认分类（一级分类模式）
  static Future<void> createFlatCategories(BeeDatabase db, AppLocalizations l10n) async {
    // 创建支出分类
    for (var i = 0; i < flatExpenseCategoryKeys.length; i++) {
      final key = flatExpenseCategoryKeys[i];
      final translatedName = _getTranslatedCategoryName(key, 'expense', l10n);

      logger.info('seed_service', '创建支出分类: key=$key, name=$translatedName');

      await db.into(db.categories).insert(
        CategoriesCompanion.insert(
          name: translatedName, // 使用翻译后的名称
          kind: 'expense',
          icon: Value(getDefaultIcon(key)),
          sortOrder: Value(i),
          level: const Value(1),
        ),
      );
    }

    // 创建收入分类
    for (var i = 0; i < flatIncomeCategoryKeys.length; i++) {
      final key = flatIncomeCategoryKeys[i];
      final translatedName = _getTranslatedCategoryName(key, 'income', l10n);

      logger.info('seed_service', '创建收入分类: key=$key, name=$translatedName');

      await db.into(db.categories).insert(
        CategoriesCompanion.insert(
          name: translatedName, // 使用翻译后的名称
          kind: 'income',
          icon: Value(getDefaultIcon(key)),
          sortOrder: Value(i),
          level: const Value(1),
        ),
      );
    }
  }

  /// 生成默认分类（二级分类模式）
  static Future<void> createHierarchicalCategories(BeeDatabase db, AppLocalizations l10n) async {
    // 创建支出分类
    var sortOrder = 0;
    for (final entry in hierarchicalExpenseCategories.entries) {
      final parentKey = entry.key;
      final childKeys = entry.value;

      final parentTranslatedName = _getTranslatedParentCategoryName(parentKey, 'expense', l10n);
      logger.info('seed_service', '创建支出父分类: key=$parentKey, name=$parentTranslatedName');

      // 创建父分类
      final parentId = await db.into(db.categories).insert(
        CategoriesCompanion.insert(
          name: parentTranslatedName, // 使用翻译后的名称
          kind: 'expense',
          icon: Value(getDefaultIcon(parentKey)),
          sortOrder: Value(sortOrder++),
          level: const Value(1),
        ),
      );

      // 创建子分类
      for (var i = 0; i < childKeys.length; i++) {
        final childKey = childKeys[i];
        final childTranslatedName = _getTranslatedSubCategoryName(childKey, 'expense', l10n);

        logger.info('seed_service', '创建支出子分类: key=$childKey, name=$childTranslatedName');

        await db.into(db.categories).insert(
          CategoriesCompanion.insert(
            name: childTranslatedName, // 使用翻译后的名称
            kind: 'expense',
            icon: Value(getDefaultIcon(childKey)),
            sortOrder: Value(i),
            level: const Value(2),
            parentId: Value(parentId),
          ),
        );
      }
    }

    // 创建收入分类
    sortOrder = 0;
    for (final entry in hierarchicalIncomeCategories.entries) {
      final parentKey = entry.key;
      final childKeys = entry.value;

      final parentTranslatedName = _getTranslatedParentCategoryName(parentKey, 'income', l10n);
      logger.info('seed_service', '创建收入父分类: key=$parentKey, name=$parentTranslatedName');

      // 创建父分类
      final parentId = await db.into(db.categories).insert(
        CategoriesCompanion.insert(
          name: parentTranslatedName, // 使用翻译后的名称
          kind: 'income',
          icon: Value(getDefaultIcon(parentKey)),
          sortOrder: Value(sortOrder++),
          level: const Value(1),
        ),
      );

      // 创建子分类
      for (var i = 0; i < childKeys.length; i++) {
        final childKey = childKeys[i];
        final childTranslatedName = _getTranslatedSubCategoryName(childKey, 'income', l10n);

        logger.info('seed_service', '创建收入子分类: key=$childKey, name=$childTranslatedName');

        await db.into(db.categories).insert(
          CategoriesCompanion.insert(
            name: childTranslatedName, // 使用翻译后的名称
            kind: 'income',
            icon: Value(getDefaultIcon(childKey)),
            sortOrder: Value(i),
            level: const Value(2),
            parentId: Value(parentId),
          ),
        );
      }
    }
  }

  /// 完整的种子数据初始化
  ///
  /// [l10n] 国际化对象，用于获取翻译后的名称
  /// [currency] 默认货币代码（如 'CNY', 'USD'）
  /// [useHierarchicalCategories] 是否使用二级分类模式
  static Future<void> seedDatabase(
    BeeDatabase db,
    AppLocalizations l10n, {
    String currency = 'CNY',
    bool useHierarchicalCategories = false,
  }) async {
    logger.info('seed', '开始初始化数据库');
    logger.info('seed', '货币: $currency');
    logger.info('seed', '分类模式: ${useHierarchicalCategories ? "二级分类" : "一级分类"}');
    logger.info('seed', '账本名称: ${l10n.ledgerDefaultName}');
    logger.info('seed', '现金账户名: ${l10n.accountTypeCash}');

    // 1. 创建默认账本
    final ledgerId = await createDefaultLedger(db, l10n, currency);
    logger.info('seed', '已创建账本 ID: $ledgerId');

    // 2. 创建默认账户（3个：现金、银行卡、信用卡）
    await createDefaultAccounts(db, ledgerId, l10n, currency);
    logger.info('seed', '已创建3个账户');

    // 3. 创建默认分类
    if (useHierarchicalCategories) {
      await createHierarchicalCategories(db, l10n);
      logger.info('seed', '已创建二级分类');
    } else {
      await createFlatCategories(db, l10n);
      logger.info('seed', '已创建一级分类');
    }

    logger.info('seed', '数据库初始化完成');
  }
}
