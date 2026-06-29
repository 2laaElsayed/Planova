import 'package:flutter/material.dart';

class AvatarSquare extends StatelessWidget {
  final Color color;
  final String text;
  final double size;
  const AvatarSquare({
    super.key,
    required this.color,
    required this.text,
    this.size = 34,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
