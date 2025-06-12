import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/widget_style.dart';

class WidgetCustomizationController extends GetxController {
  final Rx<WidgetStyle> widgetStyle = WidgetStyle.defaultStyle.obs;
  final ImagePicker _imagePicker = ImagePicker();
  final RxBool _isCheckingPermission = false.obs;
  final RxBool isPickingImage = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedStyle();
  }

  Future<void> _loadSavedStyle() async {
    try {
      final savedBackgroundColor =
          await HomeWidget.getWidgetData<String>('widget_background_color');
      final savedVerseNameColor =
          await HomeWidget.getWidgetData<String>('widget_verse_name_color');
      final savedVerseTextColor =
          await HomeWidget.getWidgetData<String>('widget_verse_text_color');
      final savedBackgroundImage =
          await HomeWidget.getWidgetData<String>('widget_background_image');
      final savedUseImage =
          await HomeWidget.getWidgetData<String>('widget_use_image_background');

      if (savedBackgroundColor != null &&
          savedVerseNameColor != null &&
          savedVerseTextColor != null) {
        widgetStyle.value = WidgetStyle.fromMap({
          'backgroundColor': savedBackgroundColor,
          'verseNameColor': savedVerseNameColor,
          'verseTextColor': savedVerseTextColor,
          'backgroundImagePath': savedBackgroundImage,
          'useImageBackground': savedUseImage,
        });
      }
    } catch (e) {
      print('Error loading widget style: $e');
    }
  }

  Future<bool> _checkAndRequestPermission(Permission permission) async {
    final status = await permission.status;

    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    return false;
  }

  Future<bool> _handleStoragePermission() async {
    if (_isCheckingPermission.value) return false;
    _isCheckingPermission.value = true;

    try {
      // For Android 13 and above
      if (await Permission.photos.status.isPermanentlyDenied ||
          await Permission.storage.status.isPermanentlyDenied) {
        final result = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
              'Photo library access is required to select background images. '
              'Please enable it in app settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Open Settings'),
              ),
            ],
          ),
          barrierDismissible: false,
        );

        if (result == true) {
          await openAppSettings();
          await Future.delayed(const Duration(seconds: 1));

          // Check if permission was granted in settings
          if (Platform.isAndroid && await Permission.photos.isGranted) {
            _isCheckingPermission.value = false;
            return true;
          }
          if (await Permission.storage.isGranted) {
            _isCheckingPermission.value = false;
            return true;
          }
        }
        _isCheckingPermission.value = false;
        return false;
      }

      // Try photos permission first (for Android 13+)
      if (Platform.isAndroid) {
        final hasPhotosPermission =
            await _checkAndRequestPermission(Permission.photos);
        if (hasPhotosPermission) {
          _isCheckingPermission.value = false;
          return true;
        }
      }

      // Fallback to storage permission for older Android versions
      final hasStoragePermission =
          await _checkAndRequestPermission(Permission.storage);
      _isCheckingPermission.value = false;
      return hasStoragePermission;
    } catch (e) {
      print('Error handling permission: $e');
      _isCheckingPermission.value = false;
      return false;
    }
  }

  void updateBackgroundColor(Color color) {
    widgetStyle.value = widgetStyle.value.copyWith(
      backgroundColor: color,
      useImageBackground: false,
    );
  }

  void updateVerseNameColor(Color color) {
    widgetStyle.value = widgetStyle.value.copyWith(
      verseNameColor: color,
    );
  }

  void updateVerseTextColor(Color color) {
    widgetStyle.value = widgetStyle.value.copyWith(
      verseTextColor: color,
    );
  }

  Future<void> pickBackgroundImage() async {
    if (isPickingImage.value) return;

    try {
      isPickingImage.value = true;

      final hasPermission = await _handleStoragePermission();
      if (!hasPermission) {
        String message = 'Photo library access is required to select images.';
        bool isPermanentlyDenied = Platform.isAndroid
            ? await Permission.photos.isPermanentlyDenied
            : await Permission.storage.isPermanentlyDenied;

        if (isPermanentlyDenied) {
          message += ' Please enable it in app settings.';
        } else {
          message += ' Please try again.';
        }

        Get.snackbar(
          'Permission Required',
          message,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          mainButton: isPermanentlyDenied
              ? TextButton(
                  onPressed: () async {
                    await openAppSettings();
                  },
                  child: const Text('Settings',
                      style: TextStyle(color: Colors.white)),
                )
              : null,
        );
        return;
      }

      final XFile? image = await _imagePicker
          .pickImage(
            source: ImageSource.gallery,
            maxWidth: 1080,
            maxHeight: 1920,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException('Image picking timed out'),
          );

      if (image != null) {
        // Copy image to app's documents directory for persistence
        final directory = await getApplicationDocumentsDirectory();
        final fileName =
            'widget_background_${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';
        final savedImagePath = path.join(directory.path, fileName);

        // Create a copy of the image
        final File imageFile = File(image.path);
        await imageFile.copy(savedImagePath);

        // Update widget style
        widgetStyle.value = widgetStyle.value.copyWith(
          backgroundImagePath: savedImagePath,
          useImageBackground: true,
        );

        // Save to HomeWidget
        await HomeWidget.saveWidgetData(
            'widget_background_image', savedImagePath);
        await HomeWidget.saveWidgetData('widget_use_image_background', 'true');

        // Update the widget
        await HomeWidget.updateWidget(
          name: 'VerseWidgetProvider',
          androidName: 'VerseWidgetProvider',
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      String errorMessage = 'Failed to pick image. Please try again.';

      if (e is PlatformException) {
        if (e.code == 'photo_access_denied') {
          errorMessage = 'Photo access denied. Please check your permissions.';
        } else if (e.code == 'channel-error') {
          errorMessage =
              'Failed to connect to image picker. Please restart the app.';
        }
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isPickingImage.value = false;
    }
  }

  void toggleBackgroundType(bool useImage) async {
    if (useImage) {
      await pickBackgroundImage();
    } else {
      widgetStyle.value = widgetStyle.value.copyWith(
        useImageBackground: false,
      );
    }
  }

  Future<void> saveAndApplyStyle() async {
    try {
      final style = widgetStyle.value.toMap();

      // Verify image exists if using image background
      if (widgetStyle.value.useImageBackground &&
          widgetStyle.value.backgroundImagePath != null) {
        final imageFile = File(widgetStyle.value.backgroundImagePath!);
        if (!await imageFile.exists()) {
          throw Exception('Background image not found');
        }
      }

      await HomeWidget.saveWidgetData(
          'widget_background_color', style['backgroundColor']);
      await HomeWidget.saveWidgetData(
          'widget_verse_name_color', style['verseNameColor']);
      await HomeWidget.saveWidgetData(
          'widget_verse_text_color', style['verseTextColor']);
      await HomeWidget.saveWidgetData(
          'widget_background_image', style['backgroundImagePath']);
      await HomeWidget.saveWidgetData(
          'widget_use_image_background', style['useImageBackground']);

      await HomeWidget.updateWidget(
        androidName: 'VerseWidgetProvider',
        iOSName: 'VerseWidget',
      );

      Get.snackbar(
        'Success',
        'Widget style updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update widget style: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      print('Error saving widget style: $e');
    }
  }
}
