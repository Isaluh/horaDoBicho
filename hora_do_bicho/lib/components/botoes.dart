import 'package:flutter/material.dart';

class ElevatedButtonComponent extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double? paddingVertical;
  final double? paddingHorizontal;
  final Size minimumSize;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;
  final double? borderWidth;

  const ElevatedButtonComponent({
    super.key, 
    required this.onPressed,
    required this.text,
    this.color = Colors.black, 
    this.textColor = Colors.white, 
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.normal,
    this.paddingVertical = 10.0,
    this.paddingHorizontal = 20.0,
    this.minimumSize = const Size(0.0, 0.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.borderColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius!,
          side: BorderSide(
            color: borderColor ?? Colors.transparent,
            width: borderWidth ?? 0,
          ),
        ),
        minimumSize: minimumSize,
        padding: EdgeInsets.symmetric(
          vertical: paddingVertical!,
          horizontal: paddingHorizontal!,
        ),
        textStyle: TextStyle(fontWeight: fontWeight),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
        ),
      ),
    );
  }
}
