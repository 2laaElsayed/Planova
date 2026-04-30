import 'package:flutter/material.dart';
import 'custom_dropdown.dart';

class TaskOptionsRow extends StatefulWidget {
  const TaskOptionsRow({super.key});

  @override
  State<TaskOptionsRow> createState() => _TaskOptionsRowState();
}

class _TaskOptionsRowState extends State<TaskOptionsRow> {
  String? priority;
  String? group;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          
          child: CustomDropdown(
            icon :Icon(Icons.outlined_flag , color: Color(0xFFE57373),),
            label: "Priority",
            items: const ["High", "Medium", "Low"],
            value: priority,
            onChanged: (val) {
              setState(() {
                priority = val;
              });
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomDropdown(
            icon :Icon(Icons.group , color: Color(0xFF9BA3EB),),
            label: "Group",
            items: const ["Work", "Personal", "Health", "Study"],
            value: group,
            onChanged: (val) {
              setState(() {
                group = val;
              });
            },
          ),
        ),
      ],
    );
  }
}