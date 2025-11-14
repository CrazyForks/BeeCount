import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import '../../widgets/ui/ui.dart';
import '../../widgets/biz/section_card.dart';
import '../../data/db.dart' as db;
import '../../l10n/app_localizations.dart';
import '../../utils/sync_helpers.dart';
import '../../styles/colors.dart';
import '../../utils/ui_scale_extensions.dart';

class AccountEditPage extends ConsumerStatefulWidget {
  final db.Account? account; // null表示新建
  final int ledgerId;

  const AccountEditPage({
    super.key,
    this.account,
    required this.ledgerId,
  });

  @override
  ConsumerState<AccountEditPage> createState() => _AccountEditPageState();
}

class _AccountEditPageState extends ConsumerState<AccountEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _initialBalanceController;
  late String _selectedType;
  bool _saving = false;

  // 预设账户类型
  static const List<String> accountTypes = [
    'cash',
    'bank_card',
    'credit_card',
    'alipay',
    'wechat',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account?.name ?? '');
    _initialBalanceController = TextEditingController(
      text: widget.account?.initialBalance != null &&
              widget.account!.initialBalance != 0.0
          ? widget.account!.initialBalance.toStringAsFixed(2)
          : '',
    );
    _selectedType = widget.account?.type ?? 'cash';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _initialBalanceController.dispose();
    super.dispose();
  }

  bool get isEditing => widget.account != null;

  IconData _getIconForType(String type) {
    switch (type) {
      case 'cash':
        return Icons.payments_outlined;
      case 'bank_card':
        return Icons.credit_card;
      case 'credit_card':
        return Icons.credit_score;
      case 'alipay':
        return Icons.currency_yuan; // 使用￥符号代表支付宝
      case 'wechat':
        return Icons.chat; // 使用聊天图标代表微信
      case 'other':
        return Icons.account_balance_outlined;
      default:
        return Icons.account_balance_wallet_outlined;
    }
  }

  String _getTypeLabel(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context);
    switch (type) {
      case 'cash':
        return l10n.accountTypeCash;
      case 'bank_card':
        return l10n.accountTypeBankCard;
      case 'credit_card':
        return l10n.accountTypeCreditCard;
      case 'alipay':
        return l10n.accountTypeAlipay;
      case 'wechat':
        return l10n.accountTypeWechat;
      case 'other':
        return l10n.accountTypeOther;
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final primaryColor = ref.watch(primaryColorProvider);

    return Scaffold(
      backgroundColor: BeeColors.greyBg,
      body: Column(
        children: [
          PrimaryHeader(
            title: isEditing ? l10n.accountEditTitle : l10n.accountNewTitle,
            showBack: true,
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.0.scaled(context, ref),
                  vertical: 8.0.scaled(context, ref),
                ),
                children: [
                  // 账户名称
                  SectionCard(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.all(16.0.scaled(context, ref)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.accountNameLabel,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: BeeColors.primaryText,
                            ),
                          ),
                          SizedBox(height: 12.0.scaled(context, ref)),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: l10n.accountNameHint,
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor, width: 2),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0.scaled(context, ref),
                              ),
                            ),
                            style: const TextStyle(fontSize: 16),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.accountNameRequired;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 8.0.scaled(context, ref)),

                  // 账户类型
                  SectionCard(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.all(16.0.scaled(context, ref)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.accountTypeLabel,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: BeeColors.primaryText,
                            ),
                          ),
                          SizedBox(height: 16.0.scaled(context, ref)),
                          GridView.count(
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 12.0.scaled(context, ref),
                            crossAxisSpacing: 12.0.scaled(context, ref),
                            childAspectRatio: 1.2,
                            children: accountTypes.map((type) {
                              final isSelected = _selectedType == type;
                              return _AccountTypeCard(
                                type: type,
                                icon: _getIconForType(type),
                                label: _getTypeLabel(context, type),
                                isSelected: isSelected,
                                primaryColor: primaryColor,
                                onTap: () {
                                  setState(() {
                                    _selectedType = type;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 8.0.scaled(context, ref)),

                  // 初始资金
                  SectionCard(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.all(16.0.scaled(context, ref)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.accountInitialBalance,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: BeeColors.primaryText,
                            ),
                          ),
                          SizedBox(height: 12.0.scaled(context, ref)),
                          TextFormField(
                            controller: _initialBalanceController,
                            decoration: InputDecoration(
                              hintText: l10n.accountInitialBalanceHint,
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixText: '¥ ',
                              prefixStyle: TextStyle(
                                fontSize: 16,
                                color: BeeColors.primaryText,
                              ),
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor, width: 2),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0.scaled(context, ref),
                              ),
                            ),
                            style: const TextStyle(fontSize: 16),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (value) {
                              if (value != null && value.trim().isNotEmpty) {
                                final parsed = double.tryParse(value.trim());
                                if (parsed == null) {
                                  return '请输入有效的金额';
                                }
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24.0.scaled(context, ref)),

                  // 保存按钮
                  SizedBox(
                    width: double.infinity,
                    height: 48.0.scaled(context, ref),
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8.0.scaled(context, ref)),
                        ),
                      ),
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Text(
                              l10n.commonSave,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  // 删除按钮（仅编辑时显示）
                  if (isEditing) ...[
                    SizedBox(height: 12.0.scaled(context, ref)),
                    SizedBox(
                      width: double.infinity,
                      height: 48.0.scaled(context, ref),
                      child: OutlinedButton(
                        onPressed: _saving ? null : _delete,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0.scaled(context, ref)),
                          ),
                        ),
                        child: Text(
                          l10n.commonDelete,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      final repo = ref.read(repositoryProvider);
      final name = _nameController.text.trim();
      final initialBalanceText = _initialBalanceController.text.trim();
      final initialBalance =
          initialBalanceText.isEmpty ? 0.0 : double.parse(initialBalanceText);

      if (isEditing) {
        await repo.updateAccount(
          widget.account!.id,
          name: name,
          type: _selectedType,
          initialBalance: initialBalance,
        );
      } else {
        await repo.createAccount(
          ledgerId: widget.ledgerId,
          name: name,
          type: _selectedType,
          initialBalance: initialBalance,
        );
      }

      // 触发账本同步(后台异步,不阻塞页面关闭)
      if (mounted) {
        handleLocalChange(ref, ledgerId: widget.ledgerId, background: true);
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('${AppLocalizations.of(context).commonError}: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);

    // 检查是否有关联交易
    final repo = ref.read(repositoryProvider);
    final txCount = await repo.getTransactionCountByAccount(widget.account!.id);

    if (txCount > 0) {
      // 有关联交易，提示用户
      if (!mounted) return;
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.accountDeleteWarningTitle),
          content: Text(l10n.accountDeleteWarningMessage(txCount)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.commonDelete),
            ),
          ],
        ),
      );

      if (confirm != true) return;
    } else {
      // 没有关联交易，简单确认
      if (!mounted) return;
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.commonConfirm),
          content: Text(l10n.accountDeleteConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.commonDelete),
            ),
          ],
        ),
      );

      if (confirm != true) return;
    }

    setState(() => _saving = true);

    try {
      await repo.deleteAccount(widget.account!.id);

      // 触发账本同步(后台异步,不阻塞页面关闭)
      if (mounted) {
        handleLocalChange(ref, ledgerId: widget.ledgerId, background: true);
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.commonError}: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}

/// 账户类型选择卡片
class _AccountTypeCard extends ConsumerWidget {
  final String type;
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color primaryColor;
  final VoidCallback onTap;

  const _AccountTypeCard({
    required this.type,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0.scaled(context, ref)),
      child: Container(
        decoration: BoxDecoration(
          color:
              isSelected ? primaryColor.withValues(alpha: 0.12) : Colors.white,
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8.0.scaled(context, ref)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : BeeColors.secondaryText,
              size: 28.0.scaled(context, ref),
            ),
            SizedBox(height: 8.0.scaled(context, ref)),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? primaryColor : BeeColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
