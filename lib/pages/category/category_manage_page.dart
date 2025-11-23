import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import '../../providers.dart';
import '../../providers/database_providers.dart';
import '../../widgets/ui/ui.dart';
import '../../widgets/category/subcategory_container.dart';
import '../../data/db.dart' as db;
import '../../services/category_service.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/category_utils.dart';
import '../../styles/tokens.dart';
import 'category_edit_page.dart';

class CategoryManagePage extends ConsumerStatefulWidget {
  final int initialTabIndex; // 0: 支出, 1: 收入

  const CategoryManagePage({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  ConsumerState<CategoryManagePage> createState() => _CategoryManagePageState();
}

class _CategoryManagePageState extends ConsumerState<CategoryManagePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(() {
      setState(() {}); // 重新构建以更新按钮状态
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesWithCountAsync = ref.watch(categoriesWithCountProvider);

    return Scaffold(
      body: Column(
        children: [
          PrimaryHeader(
            title: AppLocalizations.of(context).categoryTitle,
            showBack: true,
            actions: [
              IconButton(
                onPressed: () => _addCategory(),
                icon: const Icon(Icons.add),
                tooltip: AppLocalizations.of(context).categoryNew,
              ),
            ],
          ),
          TabBar(
            controller: _tabController,
            labelColor: BeeTokens.textPrimary(context),
            unselectedLabelColor: BeeTokens.textSecondary(context),
            tabs: [
              Tab(text: AppLocalizations.of(context).categoryExpense),
              Tab(text: AppLocalizations.of(context).categoryIncome),
            ],
          ),
          Expanded(
            child: categoriesWithCountAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text(AppLocalizations.of(context).categoryLoadFailed(error.toString()))),
              data: (categoriesWithCount) {
                return Column(
                  children: [
                    // 提示信息
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: BeeTokens.isDark(context) ? Colors.blue[900]!.withValues(alpha: 0.3) : Colors.blue[50],
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: BeeTokens.isDark(context) ? Colors.blue[300] : Colors.blue[700]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context).categoryReorderTip,
                              style: TextStyle(
                                fontSize: 12,
                                color: BeeTokens.isDark(context) ? Colors.blue[300] : Colors.blue[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _CategoryGridView(
                            categoriesWithCount: categoriesWithCount,
                            kind: 'expense',
                          ),
                          _CategoryGridView(
                            categoriesWithCount: categoriesWithCount,
                            kind: 'income',
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addCategory() async {
    final kind = _tabController.index == 0 ? 'expense' : 'income';
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryEditPage(kind: kind),
      ),
    );
  }
}

class _CategoryGridView extends ConsumerStatefulWidget {
  final List<({db.Category category, int transactionCount})> categoriesWithCount;
  final String kind;

  const _CategoryGridView({
    required this.categoriesWithCount,
    required this.kind,
  });

  @override
  ConsumerState<_CategoryGridView> createState() => _CategoryGridViewState();
}

class _CategoryGridViewState extends ConsumerState<_CategoryGridView> {
  List<_CategoryItem> _flatList = []; // 初始化为空列表
  int? _expandedCategoryId; // 当前展开的一级分类ID

  @override
  void initState() {
    super.initState();
    _buildFlatList();
  }

  @override
  void didUpdateWidget(_CategoryGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.categoriesWithCount != oldWidget.categoriesWithCount ||
        widget.kind != oldWidget.kind) {
      _buildFlatList();
    }
  }

  Future<void> _buildFlatList() async {
    // 获取当前类型的一级分类
    final topLevelCategories = widget.categoriesWithCount
        .where((item) =>
            item.category.kind == widget.kind &&
            item.category.level == 1)
        .toList();

    // 按 sortOrder 排序
    topLevelCategories.sort((a, b) => a.category.sortOrder.compareTo(b.category.sortOrder));

    final repo = ref.read(repositoryProvider);
    final flatList = <_CategoryItem>[];

    for (final topItem in topLevelCategories) {
      // 检查是否有子分类
      final subCategories = await repo.getSubCategories(topItem.category.id);
      final hasSubCategories = subCategories.isNotEmpty;

      // 添加一级分类
      flatList.add(_CategoryItem(
        category: topItem.category,
        transactionCount: topItem.transactionCount,
        isDefault: false, // 所有分类都可删除
        isSubCategory: false,
        hasSubCategories: hasSubCategories,
      ));

      // 如果展开，添加二级分类 + 操作按钮
      if (_expandedCategoryId == topItem.category.id && hasSubCategories) {
        for (final subCat in subCategories) {
          // 查找二级分类的交易数量
          final subCount = widget.categoriesWithCount
              .firstWhere(
                (item) => item.category.id == subCat.id,
                orElse: () => (category: subCat, transactionCount: 0),
              )
              .transactionCount;

          flatList.add(_CategoryItem(
            category: subCat,
            transactionCount: subCount,
            isDefault: false,
            isSubCategory: true,
            parent: topItem.category,
          ));
        }

        // 添加操作按钮项（加号和编辑按钮）
        flatList.add(_CategoryItem(
          category: topItem.category, // 使用父分类
          transactionCount: 0,
          isDefault: false,
          isSubCategory: false,
          isActionButtons: true, // 标记为操作按钮项
        ));
      }
    }

    if (mounted) {
      setState(() {
        _flatList = flatList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_flatList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 64,
              color: BeeTokens.textTertiary(context),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).categoryEmpty,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: BeeTokens.textSecondary(context),
              ),
            ),
          ],
        ),
      );
    }

    // 使用 ListView 来混合显示 GridView 和 SubcategoryContainer
    return FutureBuilder<Map<int, List<({db.Category category, int transactionCount})>>>(
      future: _loadSubCategoriesMap(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final subCategoriesMap = snapshot.data!;
        final topLevelCategories = _flatList
            .where((item) => !item.isSubCategory && !item.isActionButtons)
            .toList();

        // 查找展开的分类
        _CategoryItem? expandedItem;
        if (_expandedCategoryId != null) {
          for (int i = 0; i < topLevelCategories.length; i++) {
            if (topLevelCategories[i].category.id == _expandedCategoryId &&
                topLevelCategories[i].hasSubCategories) {
              expandedItem = topLevelCategories[i];
              break;
            }
          }
        }

        // 构建显示项列表
        final displayItems = <Widget>[];

        // 使用单一的 ReorderableGridView 来支持跨行拖拽
        displayItems.add(
          ReorderableGridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: topLevelCategories.length,
            onReorder: (oldIndex, newIndex) {
              // 直接使用一级分类列表的索引进行重排
              _onReorderTopLevel(oldIndex, newIndex, topLevelCategories);
            },
            itemBuilder: (context, index) {
              final item = topLevelCategories[index];
              return _CategoryCard(
                key: ValueKey(item.category.id),
                item: item,
                isExpanded: _expandedCategoryId == item.category.id,
                onTap: () => _onCategoryTap(item),
              );
            },
          ),
        );

        // 如果有展开的分类，在网格下方添加二级分类容器
        if (expandedItem != null) {
          final subCategories = subCategoriesMap[expandedItem.category.id] ?? [];
          displayItems.add(
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SubcategoryContainer(
                key: ValueKey('sub_${expandedItem.category.id}'),
                parentCategory: expandedItem.category,
                subCategories: subCategories,
                onSubCategoryTap: (cat) => _onEditCategory(cat),
                onAddSubCategory: () => _onAddSubCategory(expandedItem!.category),
                onEditParentCategory: () => _onEditCategory(expandedItem!.category),
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: displayItems,
        );
      },
    );
  }

  Future<void> _onReorderTopLevel(int oldIndex, int newIndex, List<_CategoryItem> topLevelCategories) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    // 1. 立即更新本地状态（乐观更新），避免UI闪回
    final reorderedItems = List<_CategoryItem>.from(topLevelCategories);
    final movedItem = reorderedItems.removeAt(oldIndex);
    reorderedItems.insert(newIndex, movedItem);

    // 重建 _flatList，保持一级分类的新顺序
    setState(() {
      _flatList = reorderedItems;
    });

    // 2. 批量保存到数据库
    final database = ref.read(databaseProvider);
    await database.batch((batch) {
      for (var i = 0; i < reorderedItems.length; i++) {
        final category = reorderedItems[i].category;
        batch.update(
          database.categories,
          db.CategoriesCompanion(sortOrder: drift.Value(i)),
          where: (c) => c.id.equals(category.id),
        );
      }
    });

    // 3. 刷新 provider 以同步其他地方的数据
    ref.invalidate(categoriesWithCountProvider);
  }


  void _onCategoryTap(_CategoryItem item) async {
    if (item.isSubCategory) {
      // 二级分类：直接编辑
      await _onEditCategory(item.category);
    } else {
      // 一级分类：检查是否有子分类
      if (item.hasSubCategories) {
        // 有子分类：切换展开/折叠
        setState(() {
          if (_expandedCategoryId == item.category.id) {
            _expandedCategoryId = null;
          } else {
            _expandedCategoryId = item.category.id;
          }
        });
        await _buildFlatList();
      } else {
        // 无子分类：直接编辑
        await _onEditCategory(item.category);
      }
    }
  }

  Future<void> _onEditCategory(db.Category category) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryEditPage(
          category: category,
          kind: category.kind,
        ),
      ),
    );
  }

  Future<void> _onAddSubCategory(db.Category parent) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryEditPage(
          kind: parent.kind,
          parentCategory: parent,
        ),
      ),
    );
    await _buildFlatList();
  }

  Future<Map<int, List<({db.Category category, int transactionCount})>>> _loadSubCategoriesMap() async {
    final repo = ref.read(repositoryProvider);
    final result = <int, List<({db.Category category, int transactionCount})>>{};

    final topLevelCategories = _flatList
        .where((item) => !item.isSubCategory && !item.isActionButtons)
        .toList();

    for (final topItem in topLevelCategories) {
      final subCategories = await repo.getSubCategories(topItem.category.id);
      if (subCategories.isNotEmpty) {
        final subCategoriesWithCount = <({db.Category category, int transactionCount})>[];
        for (final subCat in subCategories) {
          // 查找二级分类的交易数量
          final subCount = widget.categoriesWithCount
              .firstWhere(
                (item) => item.category.id == subCat.id,
                orElse: () => (category: subCat, transactionCount: 0),
              )
              .transactionCount;

          subCategoriesWithCount.add((category: subCat, transactionCount: subCount));
        }
        result[topItem.category.id] = subCategoriesWithCount;
      }
    }

    return result;
  }
}

class _CategoryItem {
  final db.Category category;
  final int transactionCount;
  final bool isDefault;
  final bool isSubCategory;
  final db.Category? parent;
  final bool hasSubCategories;
  final bool isActionButtons; // 是否为操作按钮项

  _CategoryItem({
    required this.category,
    required this.transactionCount,
    required this.isDefault,
    required this.isSubCategory,
    this.parent,
    this.hasSubCategories = false,
    this.isActionButtons = false,
  });
}

class _CategoryCard extends ConsumerWidget {
  final _CategoryItem item;
  final bool isExpanded;
  final VoidCallback onTap;

  const _CategoryCard({
    super.key,
    required this.item,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 二级分类：使用浅色背景
    final backgroundColor = item.isSubCategory
        ? Colors.orange[50]
        : Theme.of(context).colorScheme.surface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: item.isSubCategory
                ? Colors.orange.withValues(alpha: 0.3)
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: item.isSubCategory ? 28 : 32,
                    height: item.isSubCategory ? 28 : 32,
                    decoration: BoxDecoration(
                      color: item.isSubCategory
                          ? Colors.orange.withValues(alpha: 0.2)
                          : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CategoryService.getCategoryIcon(item.category.icon),
                      color: item.isSubCategory
                          ? Colors.orange[700]
                          : Theme.of(context).colorScheme.primary,
                      size: item.isSubCategory ? 16 : 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      CategoryUtils.getDisplayName(item.category.name, context),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: item.isSubCategory ? 10 : 12,
                            color: item.isSubCategory ? Colors.orange[900] : null,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppLocalizations.of(context).categoryMigrationTransactionLabel(item.transactionCount),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: item.isSubCategory
                              ? Colors.orange[700]
                              : Theme.of(context).colorScheme.outline,
                          fontSize: item.isSubCategory ? 9 : 10,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // 有子分类的一级分类：右下角显示展开/折叠指示器
            if (!item.isSubCategory && item.hasSubCategories)
              Positioned(
                right: 4,
                bottom: 4,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

