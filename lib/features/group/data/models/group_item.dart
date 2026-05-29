import 'package:flutter/material.dart';

enum ViewMode { list, grid }

enum ScopeTab { all, team, personal }

enum ActivityFilter { all, active, completed, archived }

enum GroupLife { active, idle, completed, archived }

extension GroupLifeX on GroupLife {
  String get badge {
    switch (this) {
      case GroupLife.active:
        return 'ACTIVE';
      case GroupLife.idle:
        return 'IDLE';
      case GroupLife.completed:
        return 'COMPLETED';
      case GroupLife.archived:
        return 'ARCHIVED';
    }
  }

  Color get dotColor {
    switch (this) {
      case GroupLife.active:
        return const Color(0xFF2CC56F);
      case GroupLife.idle:
        return const Color(0xFFB8BDC9);
      case GroupLife.completed:
        return const Color(0xFF5AA9FF);
      case GroupLife.archived:
        return const Color(0xFF9AA1B2);
    }
  }

  String get stringValue => toString().split('.').last;

  static GroupLife fromString(String s) =>
      GroupLife.values.firstWhere((e) => e.toString().split('.').last == s);
}

class GroupItem {
  final String title;
  final GroupLife life;
  final String lastSeen;
  final double progress;
  final ScopeTab scope; 
  final Color accent;
  final int membersExtra;
  final int comments;
  final List<String> memberInitials;

  const GroupItem({
    required this.title,
    required this.life,
    required this.lastSeen,
    required this.progress,
    required this.scope,
    required this.accent,
    this.membersExtra = 4,
    this.comments = 22,
    this.memberInitials = const ['A', 'M'],
  });
}
