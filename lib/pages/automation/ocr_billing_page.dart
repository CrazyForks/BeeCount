import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:drift/drift.dart' as drift;
import '../../services/ocr_service.dart';
import '../../services/category_matcher.dart';
import '../../widgets/ui/primary_header.dart';
import '../../providers.dart';
import '../../data/db.dart';
import '../../l10n/app_localizations.dart';
import '../category/category_picker.dart';

/// OCR扫描记账页面
class OcrBillingPage extends ConsumerStatefulWidget {
  const OcrBillingPage({super.key});

  @override
  ConsumerState<OcrBillingPage> createState() => _OcrBillingPageState();
}

class _OcrBillingPageState extends ConsumerState<OcrBillingPage> {
  final _ocrService = OcrService();
  final _imagePicker = ImagePicker();

  File? _selectedImage;
  OcrResult? _ocrResult;
  bool _isProcessing = false;
  String? _selectedAmount;

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _ocrResult = null;
          _selectedAmount = null;
        });

        await _processImage();
      }
    } catch (e) {
      if (!mounted) return;
      _showError('选择图片失败: $e');
    }
  }

  Future<void> _processImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // OCR识别
      final ocrResult = await _ocrService.recognizePaymentImage(_selectedImage!);

      // 获取所有分类用于匹配
      final db = ref.read(databaseProvider);
      final categories = await (db.select(db.categories)
            ..where((t) => t.kind.equals('expense')))
          .get();

      // 智能匹配分类
      final suggestedCategoryId = CategoryMatcher.smartMatch(
        merchant: ocrResult.merchant,
        fullText: ocrResult.rawText,
        categories: categories,
      );

      // 打印识别结果用于调试
      print('📋 OCR识别原始文本:\n${ocrResult.rawText}');
      print('💰 识别到的金额: ${ocrResult.amount}');
      print('🏪 识别到的商家: ${ocrResult.merchant}');
      print('⏰ 识别到的时间: ${ocrResult.time}');
      print('🔢 所有数字: ${ocrResult.allNumbers}');
      print('🏷️ 推荐分类ID: $suggestedCategoryId');

      // 创建带有推荐分类的结果
      final result = OcrResult(
        amount: ocrResult.amount,
        merchant: ocrResult.merchant,
        time: ocrResult.time,
        rawText: ocrResult.rawText,
        allNumbers: ocrResult.allNumbers,
        suggestedCategoryId: suggestedCategoryId,
      );

      setState(() {
        _ocrResult = result;
        _selectedAmount = result.amount?.toString();
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      if (!mounted) return;
      _showError('识别失败: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<Category?> _getCategory(int categoryId) async {
    final db = ref.read(databaseProvider);
    return await (db.select(db.categories)
          ..where((t) => t.id.equals(categoryId)))
        .getSingleOrNull();
  }

  Future<void> _createTransaction() async {
    if (_selectedAmount == null || _selectedAmount!.isEmpty) {
      _showError('请选择或输入金额');
      return;
    }

    final amount = double.tryParse(_selectedAmount!);
    if (amount == null || amount <= 0) {
      _showError('请输入有效金额');
      return;
    }

    // 优先使用推荐的分类，如果没有则使用第一个支出分类
    int? categoryId = _ocrResult?.suggestedCategoryId;

    if (categoryId == null) {
      final db = ref.read(databaseProvider);
      final defaultCategory = await (db.select(db.categories)
            ..where((t) => t.kind.equals('expense'))
            ..orderBy([(t) => drift.OrderingTerm(expression: t.sortOrder)])
            ..limit(1))
          .getSingleOrNull();
      categoryId = defaultCategory?.id;
    }

    // 跳转到分类选择页面，并传递金额和备注
    final note = _ocrResult?.merchant != null ? '${_ocrResult!.merchant}' : '';

    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryPickerPage(
          initialKind: 'expense', // 默认支出
          quickAdd: true,
          initialAmount: amount,
          initialDate: _ocrResult?.time ?? DateTime.now(),
          initialNote: note,
          initialCategoryId: categoryId,
        ),
      ),
    );

    // 记账成功后返回
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final primaryColor = ref.watch(primaryColorProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          PrimaryHeader(
            title: l10n.ocrBilling,
            showBack: true,
          ),
          Expanded(
            child: _selectedImage == null
                ? _buildImagePicker(context, theme, l10n)
                : _buildResult(context, theme, l10n, primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_search,
            size: 80,
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          Text(
            '选择支付截图',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            '支持识别支付宝、微信支付截图',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPickButton(
                context,
                icon: Icons.photo_library,
                label: '从相册选择',
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              const SizedBox(width: 24),
              _buildPickButton(
                context,
                icon: Icons.camera_alt,
                label: '拍照',
                onTap: () => _pickImage(ImageSource.camera),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPickButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(BuildContext context, ThemeData theme, AppLocalizations l10n, Color primaryColor) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 图片预览
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _selectedImage!,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // 重新选择按钮
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedImage = null;
                  _ocrResult = null;
                  _selectedAmount = null;
                });
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.reselectImage),
            ),
            const SizedBox(height: 24),

            // 识别中或结果
            if (_isProcessing)
              Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      '正在识别...',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              )
            else if (_ocrResult != null) ...[
              _buildResultCard(context, theme, l10n, primaryColor),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, ThemeData theme, AppLocalizations l10n, Color primaryColor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '识别结果',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 金额选择
            Text(
              '金额',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),

            if (_ocrResult!.allNumbers.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _ocrResult!.allNumbers.map((number) {
                  final isSelected = _selectedAmount == number;
                  return ChoiceChip(
                    label: Text('¥$number'),
                    selected: isSelected,
                    showCheckmark: isSelected,
                    selectedColor: primaryColor,
                    backgroundColor: Colors.white,
                    disabledColor: Colors.white,
                    checkmarkColor: theme.colorScheme.onSurface,
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onSurface,
                    ),
                    side: BorderSide(
                      color: primaryColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedAmount = selected ? number : null;
                      });
                    },
                  );
                }).toList(),
              ),
            ] else ...[
              Text(
                '未识别到金额',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.orange,
                ),
              ),
            ],

            // 手动输入金额
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: '或手动输入金额',
                prefixText: '¥',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _selectedAmount = value;
                });
              },
            ),

            // 商家名称
            if (_ocrResult!.merchant != null) ...[
              const SizedBox(height: 16),
              Text(
                '商家',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _ocrResult!.merchant!,
                style: theme.textTheme.bodyLarge,
              ),
            ],

            // 推荐分类
            if (_ocrResult!.suggestedCategoryId != null) ...[
              const SizedBox(height: 16),
              FutureBuilder<Category?>(
                future: _getCategory(_ocrResult!.suggestedCategoryId!),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final category = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '推荐分类',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                category.name,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],

            // 时间
            if (_ocrResult!.time != null) ...[
              const SizedBox(height: 16),
              Text(
                '时间',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_ocrResult!.time!.year}-${_ocrResult!.time!.month.toString().padLeft(2, '0')}-${_ocrResult!.time!.day.toString().padLeft(2, '0')} ${_ocrResult!.time!.hour.toString().padLeft(2, '0')}:${_ocrResult!.time!.minute.toString().padLeft(2, '0')}',
                style: theme.textTheme.bodyLarge,
              ),
            ],

            // 原始文本（折叠）
            const SizedBox(height: 16),
            Theme(
              data: theme.copyWith(
                dividerColor: Colors.transparent,
                expansionTileTheme: ExpansionTileThemeData(
                  iconColor: primaryColor,
                  collapsedIconColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  textColor: primaryColor,
                  collapsedTextColor: theme.colorScheme.onSurface,
                ),
              ),
              child: ExpansionTile(
                title: Text(l10n.viewOriginalText),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _ocrResult!.rawText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 创建账单按钮
            FilledButton(
              onPressed: _createTransaction,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Text(l10n.createBill),
            ),
          ],
        ),
      ),
    );
  }
}
