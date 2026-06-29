import 'package:flutter/material.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/group_list_card.dart';

class GroupsListView extends StatelessWidget {
  final List<GroupEntity> groups;

  const GroupsListView({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: groups.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) =>
          GroupListCard(group: groups[i]),
    );
  }
}