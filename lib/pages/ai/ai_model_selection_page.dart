import 'package:beecount/utils/ui_scale_extensions.dart';
import 'package:beecount/widgets/biz/section_card.dart';
import 'package:beecount/widgets/ui/primary_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../styles/tokens.dart';
import '../../l10n/app_localizations.dart';

/// AI模型选择页
class AIModelSelectionPage extends ConsumerStatefulWidget {
  const AIModelSelectionPage({super.key});

  @override
  ConsumerState<AIModelSelectionPage> createState() => _AIModelSelectionPageState();
}

class _AIModelSelectionPageState extends ConsumerState<AIModelSelectionPage> {
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  bool _loading = true;
  String _glmModel = 'glm-4.6v-flash';
  String _glmVisionModel = 'glm-4.6v-flash';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _glmModel = prefs.getString('ai_glm_model') ?? _glmModel;
      _glmVisionModel = prefs.getString('ai_glm_vision_model') ?? _glmVisionModel;
      _loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) {
      return Scaffold(
        backgroundColor: BeeTokens.scaffoldBackground(context),
        body: Column(
          children: [
            PrimaryHeader(
              title: l10n.aiSettingsTitle,
              showBack: true,
            ),
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: BeeTokens.scaffoldBackground(context),
      body: Column(
        children: [
          PrimaryHeader(
            title: l10n.aiSettingsTitle,
            subtitle: l10n.aiSettingsSubtitle,
            showBack: true,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 12.0.scaled(context, ref),
                vertical: 8.0.scaled(context, ref),
              ),
              children: [
                // AI模型选择
                _buildModelSection(),

                SizedBox(height: 8.0.scaled(context, ref))
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildModelSection() {
    final l10n = AppLocalizations.of(context);

    return SectionCard(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Center(
            child: DropdownMenu(
              label: Text(l10n.aiModelTitle),
              initialSelection: _glmModel,
              dropdownMenuEntries: const [
                DropdownMenuEntry(
                  value: 'glm-4-flash',
                  label: 'GLM-4-Flash（快速）',
                ),
                DropdownMenuEntry(
                  value: 'glm-4.5-flash',
                  label: 'GLM-4.5-Flash（快速）',
                ),
                DropdownMenuEntry(
                  value: 'glm-4.6v-flash',
                  label: 'GLM-4.6V-Flash（准确）',
                ),
              ],
              onSelected: (value) async {
                setState(() {
                  _glmModel = value!;
                });
            
                // 立即保存选择
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('ai_glm_model', value!);
              },
            ),
          ),
          SizedBox(height: 16.0.scaled(context, ref)),
          Center(
            child: DropdownMenu(
              label: const Text('视觉模型'),
              initialSelection: _glmVisionModel,
              dropdownMenuEntries: const [
                DropdownMenuEntry(
                    value: 'glm-4v-flash',
                    label: 'GLM-4V-Flash（快速）',
                  ),
                  DropdownMenuEntry(
                    value: 'glm-4.1v-thinking-flash',
                    label: 'GLM-4.1V-Thinking-Flash',
                  ),
                  DropdownMenuEntry(
                    value: 'glm-4.6v-flash',
                    label: 'GLM-4.6V-Flash（准确）',
                  ),
              ],
              onSelected: (value) async {
                setState(() {
                  _glmVisionModel = value!;
                });
            
                // 立即保存选择
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('ai_glm_vision_model', value!);
              },
            ),
          )
        ],
      ),
    );
  }
}