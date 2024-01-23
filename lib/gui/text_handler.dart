import 'package:flutter/material.dart';

class TextHanlder {
  final Size size;

  late double width;

  TextHanlder({required this.size});
  TextStyle color16px600w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: size.width > 350 ? 16 : 11,
      color: color,
    );
  }

  TextStyle color16px400w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: size.width > 350 ? 16 : 11,
      color: color,
    );
  }

  TextStyle color16px500w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: size.width > 350 ? 16 : 11,
      color: color,
    );
  }

  TextStyle color16px700w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: size.width > 350 ? 16 : 11,
      color: color,
    );
  }

  TextStyle color15px600w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: size.width > 350 ? 15 : 10,
      color: color,
    );
  }

  TextStyle color15px400w(Color color, {bool isUnderLined = false}) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      decoration:
          !isUnderLined ? TextDecoration.none : TextDecoration.underline,
      fontSize: size.width > 350 ? 15 : 10,
      color: color,
    );
  }

  TextStyle color18px(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: size.width > 350 ? 18 : 13,
      color: color,
    );
  }

  TextStyle color18px400w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: size.width > 350 ? 18 : 13,
      color: color,
    );
  }

  TextStyle color18px600w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: size.width > 350 ? 18 : 13,
      color: color,
    );
  }

  TextStyle color30px(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: size.width > 350 ? 30 : 25,
      color: color,
    );
  }

  TextStyle color10px(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: size.width > 350 ? 10 : 5,
      color: color,
    );
  }

  TextStyle color8px(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: size.width > 350 ? 8 : 4,
      color: color,
    );
  }

  TextStyle color10px600w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: size.width > 350 ? 10 : 8,
      color: color,
    );
  }

  TextStyle color11px600w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: size.width > 350 ? 11 : 6,
      color: color,
    );
  }

  TextStyle color11px600wUnderline(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: size.width > 350 ? 11 : 6,
      color: color,
      decoration: TextDecoration.underline,
    );
  }

  TextStyle color11px(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: size.width > 350 ? 11 : 6,
      color: color,
    );
  }

  TextStyle color10px700w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: size.width > 350 ? 10 : 5,
      color: color,
    );
  }

  TextStyle color9px700w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: size.width > 350 ? 9 : 4.5,
      color: color,
    );
  }

  TextStyle color12px(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: size.width > 350 ? 12 : 7,
      color: color,
    );
  }

  TextStyle color13px700w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: size.width > 350 ? 13 : 8,
      color: color,
    );
  }

  TextStyle color13px400w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: size.width > 350 ? 13 : 8,
      color: color,
    );
  }

  TextStyle color13px600w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontSize: size.width > 350 ? 13 : 8,
      color: color,
    );
  }

  TextStyle color14px(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: size.width > 350 ? 14 : 9,
      color: color,
    );
  }

  TextStyle color14px700w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: size.width > 350 ? 14 : 9,
      color: color,
    );
  }

  TextStyle color14px600w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: size.width > 350 ? 14 : 9,
      color: color,
    );
  }

  TextStyle color14px700wUnderLine(Color color) {
    return TextStyle(
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w700,
      fontSize: size.width > 350 ? 14 : 9,
      color: color,
    );
  }

  TextStyle color13px700wUnderLine(Color color) {
    return TextStyle(
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w700,
      fontSize: size.width > 350 ? 13 : 8,
      color: color,
    );
  }

  TextStyle color14px300w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: size.width > 350 ? 14 : 9,
      color: color,
    );
  }

  TextStyle color14px400w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: size.width > 350 ? 14 : 9,
      color: color,
    );
  }

  TextStyle color14px500w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: size.width > 350 ? 14 : 9,
      color: color,
    );
  }

  TextStyle color12px400w(Color color, {bool isItaliced = false}) {
    return TextStyle(
      fontWeight: FontWeight.w300,
      fontStyle: isItaliced ? FontStyle.italic : FontStyle.normal,
      fontSize: size.width > 350 ? 12 : 8,
      color: color,
    );
  }

  TextStyle color12px500w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: size.width > 350 ? 12 : 8,
      color: color,
    );
  }

  TextStyle color12px700w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: size.width > 350 ? 12 : 8,
      color: color,
    );
  }

  TextStyle color12px600w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: size.width > 350 ? 12 : 8,
      color: color,
    );
  }

  TextStyle color19px700w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: size.width > 350 ? 19 : 13,
      color: color,
    );
  }

  TextStyle color20px(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: size.width > 350 ? 20 : 14,
      color: color,
    );
  }

  TextStyle color27px700w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: size.width > 350 ? 27 : 21,
      color: color,
    );
  }

  TextStyle? color28px700w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: size.width > 350 ? 28 : 22,
      color: color,
    );
  }

  TextStyle color20px400w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: size.width > 350 ? 20 : 14,
      color: color,
    );
  }

  TextStyle color20px700w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: size.width > 350 ? 20 : 14,
      color: color,
    );
  }

  TextStyle color24px700w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: size.width > 350 ? 24 : 18,
      color: color,
    );
  }

  TextStyle color24px400w(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: size.width > 350 ? 24 : 18,
      color: color,
    );
  }

  TextStyle color36px(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: size.width > 350 ? 36 : 28,
      color: color,
    );
  }
}
