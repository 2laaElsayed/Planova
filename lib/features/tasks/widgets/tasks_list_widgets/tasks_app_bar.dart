import 'package:flutter/material.dart';

class TasksAppBar extends StatelessWidget {
  final VoidCallback? onAddPressed;

  const TasksAppBar({
    super.key,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Tasks",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          GestureDetector(
            onTap: onAddPressed,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color:  Color(0xFF9BA3EB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}