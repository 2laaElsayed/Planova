import 'package:flutter/material.dart';

class MembersStack extends StatelessWidget {
  final List<String> initials;
  final int extra;
  const MembersStack({super.key, required this.initials, required this.extra});

  @override
  Widget build(BuildContext context) {
    if (initials.isEmpty && extra == 0) return const SizedBox.shrink();

    return Row(
      children: [
        SizedBox(
          width: 34,
          height: 18,
          child: Stack(
            children: [
              if (initials.isNotEmpty)
                Positioned(
                  left: 0,
                  child: _smallAvatar(initials[0], Colors.orange),
                ),
              if (initials.length > 1)
                Positioned(
                  left: 12,
                  child: _smallAvatar(initials[1], Colors.blue),
                ),
            ],
          ),
        ),
        if (extra > 0)
          Text(
            '+$extra',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black45,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _smallAvatar(String t, Color c) {
    return Container(
      width: 18,
      height: 18,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.85),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.2),
      ),
      child: Text(
        t,
        style: const TextStyle(
          fontSize: 9,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
