import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import '../services/billing/bill_recognition_result.dart';
import '../services/billing/bill_creation_service.dart';
import '../services/ai/ai_constants.dart';
import '../services/ai/ai_provider_config.dart';
import '../services/ai/bill_extraction_service.dart';
import '../services/ai/ai_provider_manager.dart';
import '../services/billing/post_processor.dart';
import '../services/data/tag_seed_service.dart';
import '../services/attachment_service.dart';
import '../widgets/ui/ui.dart';

/// 图片识别记账帮助类
class ImageBillingHelper {
  /// 从相册选择图片并自动记账
  static Future<void> pickImageForBilling(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await _processImageBilling(
      context,
      ref,
      ImageSource.gallery,
    );
  }

  /// 打开相机拍照并自动记账
  static Future<void> openCameraForBilling(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await _processImageBilling(
      context,
      ref,
      ImageSource.camera,
    );
  }

  /// 处理图片识别记账（统一逻辑）
  static Future<void> _processImageBilling(
    BuildContext context,
    WidgetRef ref,
    ImageSource source,
  ) async {
    final l10n = AppLocalizations.of(context);

    try {
      // 选择图片
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        // 用户取消
        return;
      }

      if (!context.mounted) return;

      // 显示加载提示
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(l10n.aiOcrRecognizing),
                ],
              ),
            ),
          ),
        ),
      );

      // AI 视觉识别(替代历史 OCR)
      final imageFile = File(pickedFile.path);

      // 兜底:AI vision 未配置 → 关掉 loading + toast 提示用户去配置
      if (!await AIProviderManager.isCapabilityConfigured(AICapabilityType.vision)) {
        if (!context.mounted) return;
        Navigator.of(context).pop();
        showToast(context, l10n.aiNotConfiguredHint);
        return;
      }

      final billInfo = await BillExtractionService().extractFromImage(imageFile);

      if (!context.mounted) return;
      Navigator.of(context).pop();

      // billInfo == null:AI 调用失败 / 无效 / 解析不出账单(自身或网络问题)
      if (billInfo == null) {
        showToast(context, l10n.aiOcrFailed(l10n.aiNotConfiguredHint));
        return;
      }

      if (billInfo.amount == null || billInfo.amount!.abs() <= 0) {
        showToast(context, l10n.aiOcrNoAmount);
        return;
      }

      // 把 BillInfo 转成下游 BillCreationService 接受的 OcrResult
      final ocrResult = OcrResult(
        amount: billInfo.amount,
        note: billInfo.note,
        time: billInfo.time,
        aiCategoryName: billInfo.category,
        aiType: billInfo.type?.toString().split('.').last,
        aiAccountName: billInfo.account,
        aiEnhanced: true,
      );

      // 获取当前账本
      final currentLedger = await ref.read(currentLedgerProvider.future);
      if (currentLedger == null) {
        if (!context.mounted) return;
        showToast(context, l10n.aiOcrNoLedger);
        return;
      }

      // 读取智能记账设置
      final autoAddTags = ref.read(smartBillingAutoTagsProvider);
      final autoAddAttachment = ref.read(smartBillingAutoAttachmentProvider);

      // 使用BillCreationService创建交易
      final repo = ref.read(repositoryProvider);
      final billCreationService = BillCreationService(repo);

      // 确定记账方式标签
      final billingTypes = <String>[];
      if (source == ImageSource.gallery) {
        billingTypes.add(TagSeedService.billingTypeImage);
      } else {
        billingTypes.add(TagSeedService.billingTypeCamera);
      }
      // 如果使用了AI增强，添加AI标签
      if (ocrResult.aiEnhanced) {
        billingTypes.add(TagSeedService.billingTypeAi);
      }

      final note = ocrResult.note ?? '';
      final transactionId = await billCreationService.createBillTransaction(
        result: ocrResult,
        ledgerId: currentLedger.id,
        note: note.isNotEmpty ? note : null,
        billingTypes: billingTypes,
        l10n: l10n,
        autoAddTags: autoAddTags,
      );

      if (!context.mounted) return;

      if (transactionId != null) {
        // 自动保存图片附件（根据设置开关）
        if (autoAddAttachment) {
          final attachmentService = ref.read(attachmentServiceProvider);
          await attachmentService.saveAttachment(
            transactionId: transactionId,
            sourceFile: imageFile,
            index: 0,
          );
        }

        // 统一后处理：刷新UI + 触发云同步
        await PostProcessor.run(ref, ledgerId: currentLedger.id, tags: true, attachments: autoAddAttachment);

        if (context.mounted) {
          final transactionType = (ocrResult.aiType == 'income') ? 'income' : 'expense';
          final typeText = transactionType == 'income' ? l10n.aiTypeIncome : l10n.aiTypeExpense;
          final amount = ocrResult.amount!.abs().toStringAsFixed(2);
          showToast(context, l10n.aiOcrSuccess(typeText, amount));
        }
      } else {
        showToast(context, l10n.aiOcrCreateFailed);
      }
    } catch (e) {
      if (!context.mounted) return;
      // 尝试关闭可能还在显示的加载对话框
      Navigator.of(context).popUntil((route) => route.isFirst);
      showToast(context, l10n.aiOcrFailed(e.toString()));
    }
  }
}
