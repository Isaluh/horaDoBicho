import 'package:flutter/material.dart';

class GestureDetectorComponent extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  const GestureDetectorComponent({
    Key? key,
    required this.label,
    required this.onTap,
    this.color = Colors.black,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
