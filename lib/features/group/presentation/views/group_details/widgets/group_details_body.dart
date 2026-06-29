import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planova_app/core/di/service_locator.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/presentation/manager/group_details_cubit/group_details_cubit.dart';
import 'package:planova_app/features/group/presentation/manager/group_member_cubit/group_members_cubit.dart';
import 'package:planova_app/features/group/presentation/views/group_details/widgets/chat_tab.dart';
import 'package:planova_app/features/group/presentation/views/group_details/widgets/group_tabs_bar.dart';
import 'package:planova_app/features/group/presentation/views/group_details/widgets/group_top_info.dart';
import 'package:planova_app/features/group/presentation/views/group_details/widgets/members_tab.dart';
import 'package:planova_app/features/group/presentation/views/group_details/widgets/overall_progress_card.dart';
import 'package:planova_app/features/group/presentation/views/group_details/widgets/tasks_tab.dart';

class GroupDetailsBody extends StatefulWidget {
  const GroupDetailsBody({super.key, required this.groupEntity});
  final GroupEntity groupEntity;

  @override
  State<GroupDetailsBody> createState() => _GroupDetailsBodyState();
}

class _GroupDetailsBodyState extends State<GroupDetailsBody> {
  late final GroupDetailsCubit _groupDetailsCubit;

  @override
  void initState() {
    super.initState();
    _groupDetailsCubit = getIt<GroupDetailsCubit>(
      param1: widget.groupEntity.groupId,
    )
      ..watchTasks()
      ..watchChat();
  }

  @override
  void dispose() {
    _groupDetailsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _groupDetailsCubit),
        BlocProvider(
          create: (context) =>
              getIt<GroupMembersCubit>()..fetchMembers(widget.groupEntity.groupId),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        child: Column(
          children: [
            GroupTopInfo(groupEntity: widget.groupEntity),
            const SizedBox(height: 12),
            const OverallProgressCard(),
            const SizedBox(height: 12),
            const GroupTabsBar(),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                children: [
                  TasksTab(groupEntity: widget.groupEntity),
                  MembersTab(groupEntity: widget.groupEntity),
                  ChatTab(groupId: widget.groupEntity.groupId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}