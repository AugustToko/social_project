import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/material.dart';

import 'at_text.dart';
import 'dollar_text.dart';

class MySpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  /// 是否显示@somebody的背景
  final bool showAtBackground;
  final BuilderType type;

  MySpecialTextSpanBuilder(
      {this.showAtBackground: false, this.type: BuilderType.extendedText});

  @override
  TextSpan build(String data, {TextStyle textStyle, onTap}) {
    var textSpan = super.build(data, textStyle: textStyle, onTap: onTap);
    return textSpan;
  }

  @override
  SpecialText createSpecialText(String flag,
      {TextStyle textStyle, SpecialTextGestureTapCallback onTap, int index}) {
    if (flag == null || flag == "") return null;

    // index 是开始标志的结束索引，因此文本开始索引应为index-（flag.length-1）
    if (isStart(flag, AtText.flag)) {
      return AtText(textStyle, onTap,
          start: index - (AtText.flag.length - 1),
          showAtBackground: showAtBackground,
          type: type);
//    } else if (isStart(flag, EmojiText.flag)) {
//      return EmojiText(textStyle, start: index - (EmojiText.flag.length - 1));
    } else if (isStart(flag, DollarText.flag)) {
      return DollarText(textStyle, onTap,
          start: index - (DollarText.flag.length - 1), type: type);
    }
    return null;
  }
}

enum BuilderType { extendedText, extendedTextField }
