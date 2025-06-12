import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/widget_customization_controller.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class WidgetCustomizationScreen extends StatelessWidget {
  WidgetCustomizationScreen({super.key}) {
    Get.put(WidgetCustomizationController());
  }

  void _showColorPicker(BuildContext context, String title, Color currentColor,
      Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: onColorChanged,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WidgetCustomizationController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customize Widget',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => controller.saveAndApplyStyle(),
            child: Text(
              'Save',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildPreviewCard(controller, theme),
            const SizedBox(height: 24),
            _buildBackgroundSection(context, controller, theme),
            const SizedBox(height: 24),
            _buildColorOption(
              context,
              'Verse Name Color',
              controller.widgetStyle.value.verseNameColor,
              (color) => controller.updateVerseNameColor(color),
              theme,
            ),
            const SizedBox(height: 16),
            _buildColorOption(
              context,
              'Verse Text Color',
              controller.widgetStyle.value.verseTextColor,
              (color) => controller.updateVerseTextColor(color),
              theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundSection(
    BuildContext context,
    WidgetCustomizationController controller,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Background',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildBackgroundTypeButton(
                context,
                'Color',
                Icons.color_lens_outlined,
                !controller.widgetStyle.value.useImageBackground,
                () => controller.toggleBackgroundType(false),
                theme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildBackgroundTypeButton(
                context,
                'Image',
                Icons.image_outlined,
                controller.widgetStyle.value.useImageBackground,
                () => controller.toggleBackgroundType(true),
                theme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (controller.widgetStyle.value.useImageBackground)
          _buildImagePicker(controller, theme)
        else
          _buildColorOption(
            context,
            'Background Color',
            controller.widgetStyle.value.backgroundColor,
            (color) => controller.updateBackgroundColor(color),
            theme,
          ),
      ],
    );
  }

  Widget _buildBackgroundTypeButton(
    BuildContext context,
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
    ThemeData theme,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(
    WidgetCustomizationController controller,
    ThemeData theme,
  ) {
    return InkWell(
      onTap: () => controller.pickBackgroundImage(),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: controller.widgetStyle.value.backgroundImagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(controller.widgetStyle.value.backgroundImagePath!),
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 32,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select Background Image',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildPreviewCard(
      WidgetCustomizationController controller, ThemeData theme) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: controller.widgetStyle.value.useImageBackground
              ? null
              : controller.widgetStyle.value.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          image: controller.widgetStyle.value.useImageBackground &&
                  controller.widgetStyle.value.backgroundImagePath != null
              ? DecorationImage(
                  image: FileImage(
                    File(controller.widgetStyle.value.backgroundImagePath!),
                  ),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preview',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'John 3:16',
              style: theme.textTheme.titleLarge?.copyWith(
                color: controller.widgetStyle.value.verseNameColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: controller.widgetStyle.value.verseTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(
    BuildContext context,
    String title,
    Color currentColor,
    Function(Color) onColorChanged,
    ThemeData theme,
  ) {
    return InkWell(
      onTap: () =>
          _showColorPicker(context, title, currentColor, onColorChanged),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium,
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: currentColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
