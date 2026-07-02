import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_dropdown.dart';
import '../../providers/new_task_provider.dart';

class TaskOptionsRow extends StatelessWidget {
  const TaskOptionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewTaskProvider>();

    List<DropdownItemModel> groupItems = [
      DropdownItemModel(
        value: "Personal Tasks",
        icon: Icons.person,
        color: const Color(0xFF9BA3EB),
      ),
    ];

    groupItems.addAll(
      provider.availableGroups.map(
        (g) => DropdownItemModel(
          value: g.name,
          icon: Icons.group,
          color: const Color(0xFF9BA3EB),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomDropdown(
          icon: const Icon(Icons.outlined_flag, color: Color(0xFFE57373)),
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
            if (value != null) {
              provider.setPriority(value.toLowerCase());
            }
          },
        ),
        
        const SizedBox(height: 16),
        
        CustomDropdown(
          icon: const Icon(Icons.group, color: Color(0xFF9BA3EB)),
          label: "Group",
          items: groupItems,
          onChanged: (value) {
            if (value == "Personal Tasks" || value == null) {
              provider.setGroup(null, null);
            } else {
              try {
                final selectedGroup = provider.availableGroups.firstWhere(
                  (g) => g.name == value,
                );
                provider.setGroup(selectedGroup.groupId, selectedGroup.name);
              } catch (e) {
                provider.setGroup(null, null);
              }
            }
          },
        ),
      ],
    );
  }
}