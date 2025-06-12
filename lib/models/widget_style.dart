import 'package:flutter/material.dart';

class WidgetStyle {
  final Color backgroundColor;
  final Color verseNameColor;
  final Color verseTextColor;
  final String? backgroundImagePath;
  final bool useImageBackground;

  const WidgetStyle({
    required this.backgroundColor,
    required this.verseTextColor,
    required this.verseNameColor,
    this.backgroundImagePath,
    this.useImageBackground = false,
  });

  Map<String, String> toMap() {
    return {
      'backgroundColor': backgroundColor.value.toString(),
      'verseNameColor': verseNameColor.value.toString(),
      'verseTextColor': verseTextColor.value.toString(),
      'backgroundImagePath': backgroundImagePath ?? '',
      'useImageBackground': useImageBackground.toString(),
    };
  }

  factory WidgetStyle.fromMap(Map<String, dynamic> map) {
    return WidgetStyle(
      backgroundColor: Color(int.parse(map['backgroundColor'] ?? '0xFFFFFFFF')),
      verseNameColor: Color(int.parse(map['verseNameColor'] ?? '0xFF000000')),
      verseTextColor: Color(int.parse(map['verseTextColor'] ?? '0xFF000000')),
      backgroundImagePath:
          map['backgroundImagePath']?.toString()?.isNotEmpty == true
              ? map['backgroundImagePath'].toString()
              : null,
      useImageBackground: map['useImageBackground']?.toString() == 'true',
    );
  }

  static WidgetStyle get defaultStyle => const WidgetStyle(
        backgroundColor: Colors.white,
        verseNameColor: Colors.black,
        verseTextColor: Colors.black87,
        backgroundImagePath: null,
        useImageBackground: false,
      );

  WidgetStyle copyWith({
    Color? backgroundColor,
    Color? verseNameColor,
    Color? verseTextColor,
    String? backgroundImagePath,
    bool? useImageBackground,
  }) {
    return WidgetStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      verseNameColor: verseNameColor ?? this.verseNameColor,
      verseTextColor: verseTextColor ?? this.verseTextColor,
      backgroundImagePath: backgroundImagePath ?? this.backgroundImagePath,
      useImageBackground: useImageBackground ?? this.useImageBackground,
    );
  }
}
