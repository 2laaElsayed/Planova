import 'package:flutter/material.dart';
import 'custom_dropdown.dart';
import 'package:provider/provider.dart';
import '../../providers/new_task_provider.dart';

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
            icon: Icon(Icons.outlined_flag, color: Color(0xFFE57373)),
            label: "Priority",
            items: [
              DropdownItemModel(
                value: "High",
                icon: Icons.flag_outlined,
                color: Colors.red,
              ),
              DropdownItemModel(
                value: "Medium",
                icon: Icons.flag_outlined,
                color: Colors.orange,
              ),
              DropdownItemModel(
                value: "Low",
                icon: Icons.outlined_flag,
                color: Colors.green,
              ),
            ],
            onChanged: (value) {
              setState(() {
                priority = value;
              });

              context.read<NewTaskProvider>().setPriority(value!);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomDropdown(
            icon: Icon(Icons.group, color: Color(0xFF9BA3EB)),
            label: "Group",
            items: [
              DropdownItemModel(
                value: "Work",
                icon: Icons.work,
                color: Color(0xFF9BA3EB),
              ),
              DropdownItemModel(
                value: "Personal",
                icon: Icons.person,
                color: Color(0xFF9BA3EB),
              ),
              DropdownItemModel(
                value: "Health",
                icon: Icons.favorite,
                color: Color(0xFF9BA3EB),
              ),
              DropdownItemModel(
                value: "Study",
                icon: Icons.book,
                color: Color(0xFF9BA3EB),
              ),
            ],
            onChanged: (value) {
              setState(() {
                group = value;
              });

              context.read<NewTaskProvider>().setGroup(null, value!);
            },
          ),
        ),
      ],
    );
  }
}
