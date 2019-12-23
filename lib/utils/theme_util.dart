import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeUtil {
  static var textDark = TextStyle(color: Colors.grey.shade50);
  static var textLight = TextStyle(color: Colors.grey.shade900);
  static var subtitle = TextStyle(color: Colors.grey);

  @Deprecated("Use [Colors.grey.shade900]")
  static var backgroundDarkColor = Colors.grey.shade900;
  @Deprecated("Use [Colors.grey.shade50]")
  static var backgroundLightColor = Colors.grey.shade50;
}
