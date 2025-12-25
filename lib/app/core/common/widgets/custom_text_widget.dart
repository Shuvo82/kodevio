import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/app_size_theme.dart';

class CustomTextWidget extends StatelessWidget with AppSizeTheme {
  final String text;
  final Color? fontColor;
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? padding;
  final bool? softWrap;
  final TextDecoration? decoration;
  final GestureTapCallback? onTap;
  final double? letterSpacing;
  final double? height;
  final double? wordSpacing;
  const CustomTextWidget({
    super.key,
    required this.text,
    this.fontColor,
    this.fontSize,
    this.fontFamily,
    this.fontWeight,
    this.overflow,
    this.maxLines,
    this.textAlign,
    this.padding,
    this.decoration,
    this.softWrap,
    this.onTap,
    this.letterSpacing,
    this.height,
    this.wordSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle style = fontFamily != null
        ? GoogleFonts.getFont(
            fontFamily!,
            color: fontColor ?? Theme.of(context).colorScheme.tertiary,
            fontSize: fontSize ?? size.textXSmall,
            fontWeight: fontWeight ?? FontWeight.w600,
            decoration: decoration,
            letterSpacing: letterSpacing,
            height: height,
            wordSpacing: wordSpacing,
          )
        : GoogleFonts.urbanist(
            color: fontColor ?? Theme.of(context).colorScheme.tertiary,
            fontSize: fontSize ?? size.textXSmall,
            fontWeight: fontWeight ?? FontWeight.w600,
            decoration: decoration,
            letterSpacing: letterSpacing,
            height: height,
            wordSpacing: wordSpacing,
          );
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Text(
          text,
          style: style,
          softWrap: softWrap ?? true,
          maxLines: maxLines ?? 2,
          textAlign: textAlign ?? TextAlign.start,
          overflow: overflow ?? TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
