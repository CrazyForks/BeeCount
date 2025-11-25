import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../data/db.dart';
import '../../providers.dart';
import '../../styles/tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/category_utils.dart';
import '../category_icon.dart';

/// 显示分类选择器
///
/// [type] 分类类型：'income' 或 'expense'
/// [includeParentCategories] 是否包含有子分类的一级分类
/// [excludeNames] 排除的分类名称列表
/// [excludeIds] 排除的分类ID列表
/// [showTransactionCount] 是否显示交易笔数
/// [ledgerId] 如果要显示笔数，需要账本ID
/// [expandChildrenByDefault] 是否默认展开二级分类
Future<Category?> showCategorySelector(
  BuildContext context, {
  required String type,
  bool includeParentCategories = false,
  List<String>? excludeNames,
  List<int>? excludeIds,
  bool showTransactionCount = false,
  int? ledgerId,
  bool expandChildrenByDefault = false,
}) {
  return showDialog<Category>(
    context: context,
    builder: (context) => CategorySelectorDialog(
      type: type,
      includeParentCategories: includeParentCategories,
      excludeNames: excludeNames,
      excludeIds: excludeIds,
      showTransactionCount: showTransactionCount,
      ledgerId: ledgerId,
      expandChildrenByDefault: expandChildrenByDefault,
    ),
  );
}

class CategorySelectorDialog extends ConsumerStatefulWidget {
  final String type;
  final bool includeParentCategories;
  final List<String>? excludeNames;
  final List<int>? excludeIds;
  final bool showTransactionCount;
  final int? ledgerId;
  final bool expandChildrenByDefault;

  const CategorySelectorDialog({
    super.key,
    required this.type,
    this.includeParentCategories = false,
    this.excludeNames,
    this.excludeIds,
    this.showTransactionCount = false,
    this.ledgerId,
    this.expandChildrenByDefault = false,
  });

  @override
  ConsumerState<CategorySelectorDialog> createState() => _CategorySelectorDialogState();
}

class _CategorySelectorDialogState extends ConsumerState<CategorySelectorDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  Map<int, int> _transactionCounts = {};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.trim().toLowerCase();
      });
    });
    if (widget.showTransactionCount && widget.ledgerId != null) {
      _loadTransactionCounts();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 加载每个分类的交易笔数
  Future<void> _loadTransactionCounts() async {
    if (widget.ledgerId == null) return;

    try {
      final repo = ref.read(repositoryProvider);

      // 获取该账本下所有交易
      final transactions = await repo.transactionsWithCategoryAll(ledgerId: widget.ledgerId!).first;

      // 统计每个分类的笔数
      final counts = <int, int>{};
      for (final item in transactions) {
        if (item.category != null) {
          counts[item.category!.id] = (counts[item.category!.id] ?? 0) + 1;
        }
      }

      if (mounted) {
        setState(() {
          _transactionCounts = counts;
        });
      }
    } catch (e) {
      // 忽略错误
    }
  }

  /// 构建分类分组数据
  List<_CategoryGroup> _buildCategoryGroups(List<Category> allCategories) {
    // 按类型筛选
    final typedCategories = allCategories.where((c) => c.kind == widget.type).toList();

    // 应用排除规则
    final filteredCategories = typedCategories.where((c) {
      // 排除指定ID
      if (widget.excludeIds?.contains(c.id) ?? false) return false;

      // 排除指定名称
      if (widget.excludeNames?.contains(c.name) ?? false) return false;

      return true;
    }).toList();

    // 分离父分类和子分类
    final parentCategories = <Category>[];
    final childCategories = <Category>[];
    final parentIds = <int>{};

    // 第一轮：找出所有父分类
    for (final category in filteredCategories) {
      if (category.parentId != null) {
        parentIds.add(category.parentId!);
        childCategories.add(category);
      }
    }

    // 第二轮：获取所有父分类
    for (final category in filteredCategories) {
      if (category.parentId == null) {
        parentCategories.add(category);
      }
    }

    // 构建分组
    final groups = <_CategoryGroup>[];

    for (final parent in parentCategories) {
      final hasChildren = parentIds.contains(parent.id);
      final children = childCategories
          .where((c) => c.parentId == parent.id)
          .toList();

      // 判断父分类是否可选
      final isParentSelectable = !hasChildren || widget.includeParentCategories;

      // 应用搜索过滤
      if (_searchText.isNotEmpty) {
        final parentName = CategoryUtils.getDisplayName(parent.name, context).toLowerCase();
        final parentMatches = parentName.contains(_searchText);

        final matchedChildren = children.where((c) {
          final childName = CategoryUtils.getDisplayName(c.name, context).toLowerCase();
          return childName.contains(_searchText);
        }).toList();

        // 如果父分类匹配，显示所有子分类
        if (parentMatches) {
          groups.add(_CategoryGroup(
            parent: parent,
            children: children,
            isExpanded: true,
            isParentSelectable: isParentSelectable,
          ));
        } else if (matchedChildren.isNotEmpty) {
          // 如果只有子分类匹配，只显示匹配的子分类
          groups.add(_CategoryGroup(
            parent: parent,
            children: matchedChildren,
            isExpanded: true,
            isParentSelectable: isParentSelectable,
          ));
        }
      } else {
        // 无搜索时，显示所有
        groups.add(_CategoryGroup(
          parent: parent,
          children: children,
          isExpanded: widget.expandChildrenByDefault,
          isParentSelectable: isParentSelectable,
        ));
      }
    }

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final db = ref.watch(databaseProvider);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: BeeTokens.scaffoldBackground(context),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: BeeTokens.scaffoldBackground(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
        children: [
          // 顶部栏
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: BeeTokens.surfaceElevated(context),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(
                bottom: BorderSide(
                  color: BeeTokens.divider(context),
                  width: 0.5,
                ),
              ),
            ),
            child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.type == 'income'
                              ? l10n.categoryIncome
                              : l10n.categoryExpense,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: BeeTokens.textPrimary(context),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: BeeTokens.iconPrimary(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // 搜索框
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: l10n.searchCategoryHint,
                      prefixIcon: Icon(
                        Icons.search,
                        color: BeeTokens.iconTertiary(context),
                      ),
                      suffixIcon: _searchText.isNotEmpty
                          ? IconButton(
                              onPressed: () => _searchController.clear(),
                              icon: Icon(
                                Icons.clear,
                                color: BeeTokens.iconTertiary(context),
                              ),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: BeeTokens.border(context),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: ref.watch(primaryColorProvider),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      filled: true,
                      fillColor: BeeTokens.surface(context),
                    ),
                  ),
                ],
              ),
            ),
          // 分类列表
          Expanded(
            child: StreamBuilder<List<Category>>(
              stream: (db.select(db.categories)
                    ..orderBy([(c) => drift.OrderingTerm(expression: c.sortOrder)]))
                  .watch(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final groups = _buildCategoryGroups(snapshot.data!);

                if (groups.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: BeeTokens.textTertiary(context),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchText.isNotEmpty
                              ? l10n.searchNoResults
                              : l10n.categoryEmpty,
                          style: TextStyle(
                            color: BeeTokens.textTertiary(context),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return _CategoryGroupItem(
                      group: group,
                      showTransactionCount: widget.showTransactionCount,
                      transactionCounts: _transactionCounts,
                      primaryColor: ref.watch(primaryColorProvider),
                      onCategorySelected: (category) {
                        Navigator.pop(context, category);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
        ),
      ),
    );
  }
}

/// 分类分组数据
class _CategoryGroup {
  final Category parent;
  final List<Category> children;
  final bool isExpanded;
  final bool isParentSelectable;

  _CategoryGroup({
    required this.parent,
    required this.children,
    this.isExpanded = false,
    required this.isParentSelectable,
  });
}

/// 分类分组项组件
class _CategoryGroupItem extends StatefulWidget {
  final _CategoryGroup group;
  final bool showTransactionCount;
  final Map<int, int> transactionCounts;
  final Color primaryColor;
  final Function(Category) onCategorySelected;

  const _CategoryGroupItem({
    required this.group,
    required this.showTransactionCount,
    required this.transactionCounts,
    required this.primaryColor,
    required this.onCategorySelected,
  });

  @override
  State<_CategoryGroupItem> createState() => _CategoryGroupItemState();
}

class _CategoryGroupItemState extends State<_CategoryGroupItem> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.group.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final hasChildren = widget.group.children.isNotEmpty;
    final isParentSelectable = widget.group.isParentSelectable;

    return Column(
      children: [
        // 父分类
        _CategoryTile(
          category: widget.group.parent,
          showTransactionCount: widget.showTransactionCount,
          transactionCount: widget.transactionCounts[widget.group.parent.id] ?? 0,
          primaryColor: widget.primaryColor,
          isParent: hasChildren,
          isExpanded: _isExpanded,
          isSelectable: isParentSelectable,
          onTap: () {
            if (hasChildren) {
              // 如果有子分类，总是展开/收起
              setState(() {
                _isExpanded = !_isExpanded;
              });
            } else if (isParentSelectable) {
              // 如果是可选的普通分类（无子分类），则选择
              widget.onCategorySelected(widget.group.parent);
            }
          },
        ),
        // 子分类（如果展开）
        if (hasChildren && _isExpanded)
          ...widget.group.children.map((child) {
            return Padding(
              padding: const EdgeInsets.only(left: 40),
              child: _CategoryTile(
                category: child,
                showTransactionCount: widget.showTransactionCount,
                transactionCount: widget.transactionCounts[child.id] ?? 0,
                primaryColor: widget.primaryColor,
                isChild: true,
                onTap: () {
                  widget.onCategorySelected(child);
                },
              ),
            );
          }),
      ],
    );
  }
}

/// 分类项组件
class _CategoryTile extends StatelessWidget {
  final Category category;
  final bool showTransactionCount;
  final int transactionCount;
  final Color primaryColor;
  final bool isParent;
  final bool isChild;
  final bool isExpanded;
  final bool isSelectable;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.category,
    required this.showTransactionCount,
    required this.transactionCount,
    required this.primaryColor,
    this.isParent = false,
    this.isChild = false,
    this.isExpanded = false,
    this.isSelectable = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconData = getCategoryIconData(
      category: category,
      categoryName: category.name,
    );

    // 如果父分类不可选，则显示为半透明
    final opacity = isParent && !isSelectable ? 0.5 : 1.0;

    return InkWell(
      onTap: onTap,
      child: Opacity(
        opacity: opacity,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: BeeTokens.divider(context),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              // 分类图标
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  iconData,
                  color: primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // 分类名称
              Expanded(
                child: Text(
                  CategoryUtils.getDisplayName(category.name, context),
                  style: TextStyle(
                    fontSize: isChild ? 15 : 16,
                    fontWeight: isChild ? FontWeight.normal : FontWeight.w500,
                    color: BeeTokens.textPrimary(context),
                  ),
                ),
              ),
              // 交易笔数
              if (showTransactionCount && transactionCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: BeeTokens.surface(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$transactionCount',
                    style: TextStyle(
                      fontSize: 12,
                      color: BeeTokens.textSecondary(context),
                    ),
                  ),
                ),
              // 展开/收起图标（父分类总是显示）
              if (isParent)
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: BeeTokens.iconSecondary(context),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
