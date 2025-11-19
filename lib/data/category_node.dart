import 'db.dart';

/// 分类树节点
/// 用于在 UI 层组织和展示分类的层级结构
class CategoryNode {
  final Category category;
  final List<Category> children;

  CategoryNode({
    required this.category,
    this.children = const [],
  });

  bool get hasChildren => children.isNotEmpty;
  bool get isTopLevel => category.level == 1;
}

/// 分类层级构建器
/// 将扁平的分类列表转换为树形结构
class CategoryHierarchy {
  /// 构建分类树
  static List<CategoryNode> buildHierarchy(List<Category> allCategories) {
    // 分组：一级分类和二级分类
    final topLevel = <Category>[];
    final subCategories = <int, List<Category>>{}; // parentId -> children

    for (final cat in allCategories) {
      if (cat.level == 1 || cat.parentId == null) {
        topLevel.add(cat);
      } else if (cat.parentId != null) {
        subCategories.putIfAbsent(cat.parentId!, () => []).add(cat);
      }
    }

    // 按 sortOrder 排序
    topLevel.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    for (final children in subCategories.values) {
      children.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    }

    // 构建节点
    return topLevel.map((cat) {
      final children = subCategories[cat.id] ?? [];
      return CategoryNode(
        category: cat,
        children: children,
      );
    }).toList();
  }

  /// 获取所有一级分类（不包含子分类）
  static List<Category> getTopLevelOnly(List<Category> allCategories) {
    return allCategories
        .where((c) => c.level == 1 || c.parentId == null)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// 获取指定父分类的所有子分类
  static List<Category> getSubCategoriesOf(
    List<Category> allCategories,
    int parentId,
  ) {
    return allCategories
        .where((c) => c.parentId == parentId)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }
}
