import 'package:flutter/material.dart';
import 'package:planova_app/features/group/data/models/group_item.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/group_grid_card.dart';

class GroupsGridView extends StatelessWidget {
  final List<GroupItem> groups;

  const GroupsGridView({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: groups.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, i) =>
          GroupGridCard(group: groups[i]),
    );
  }
}