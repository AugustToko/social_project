import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 主题工具
class ThemeUtil {
  static var textDark = TextStyle(color: Colors.grey.shade50);
  static var textLight = TextStyle(color: Colors.grey.shade900);
  static var subtitle = TextStyle(color: Colors.grey);
  static var iconCommonColor = Colors.grey;

  @Deprecated("Use [Colors.grey.shade900]")
  static var backgroundDarkColor = Colors.grey.shade900;
  @Deprecated("Use [Colors.grey.shade50]")
  static var backgroundLightColor = Colors.grey.shade50;

  static var clipRRectBorderRadius = BorderRadius.circular(8.0);
}
