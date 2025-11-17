import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift show OrderingTerm;

import '../../data/db.dart';
import '../../providers.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/category_utils.dart';
import '../category_icon.dart';

/// 分类选择器组件
/// 用于选择收入或支出分类
class CategorySelector extends ConsumerStatefulWidget {
  /// 分类类型：'expense' 或 'income'
  final String kind;

  /// 分类选择回调
  final ValueChanged<Category> onCategorySelected;

  /// 初始选中的分类ID（可选）
  final int? initialCategoryId;

  const CategorySelector({
    super.key,
    required this.kind,
    required this.onCategorySelected,
    this.initialCategoryId,
  });

  @override
  ConsumerState<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends ConsumerState<CategorySelector> {
  final Map<int, GlobalKey> _keys = {};
  bool _scrolled = false;
  int? _selectedId; // 记录当前点击的分类用于高亮

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final q = (db.select(db.categories)
          ..where((c) => c.kind.equals(widget.kind))
          ..orderBy([(c) => drift.OrderingTerm(expression: c.sortOrder)]))
        .watch();
    return StreamBuilder<List<Category>>(
      stream: q,
      builder: (context, snap) {
        final list = snap.data ?? [];

        if (list.isEmpty) {
          return Center(child: Text(AppLocalizations.of(context)!.categoryEmpty));
        }

        // 初次渲染后滚动到初始分类顶部
        if (!_scrolled && widget.initialCategoryId != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final key = _keys[widget.initialCategoryId!];
            final ctx = key?.currentContext;
            if (ctx != null) {
              Scrollable.ensureVisible(ctx,
                  alignment: 0.0, duration: const Duration(milliseconds: 250));
              _scrolled = true;
            }
          });
        }

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemCount: list.length,
          itemBuilder: (context, i) {
            final c = list[i];
            final selected =
                widget.initialCategoryId != null && c.id == widget.initialCategoryId;
            final key = _keys.putIfAbsent(c.id, () => GlobalKey());
            return _CategoryItem(
              key: key,
              category: c,
              selected: selected || _selectedId == c.id,
              onTap: () async {
                setState(() => _selectedId = c.id);
                widget.onCategorySelected(c);
              },
            );
          },
        );
      },
    );
  }
}

/// 分类项组件
class _CategoryItem extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;
  final bool selected;

  const _CategoryItem({
    super.key,
    required this.category,
    required this.onTap,
    this.selected = false,
  });

  IconData _iconFor(Category c) => getCategoryIconData(category: c);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: selected
                  ? Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.25)
                  : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(_iconFor(category),
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            CategoryUtils.getDisplayName(category.name, context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}
