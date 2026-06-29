import 'package:flutter/material.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/features/group/data/models/group_item.dart';

class ScopeBadge extends StatelessWidget {
  final ScopeTab scope;

  const ScopeBadge({super.key, required this.scope});

  @override
  Widget build(BuildContext context) {
    final isTeam = scope == ScopeTab.team;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isTeam ? const Color(0xFFEDEBFF) : const Color(0xFFE9F4FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        isTeam ? 'Team' : 'Personal',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isTeam ? AppColors.kPrimary : const Color(0xFF5A84C9),
        ),
      ),
    );
  }
}
