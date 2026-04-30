import 'package:flutter/material.dart';

class TaskAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const TaskAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      leading: const BackButton(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}