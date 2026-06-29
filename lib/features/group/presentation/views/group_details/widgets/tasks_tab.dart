import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/presentation/manager/group_details_cubit/group_details_cubit.dart';
import 'package:planova_app/features/group/presentation/views/create_task_view.dart';
import 'package:planova_app/features/group/presentation/views/group_details/widgets/task_card.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({super.key, required this.groupEntity});
  final GroupEntity groupEntity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              const Text(
                'Tasks',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kDarkBlue,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CreateTaskView(
                        lockedGroupId: groupEntity.groupId,
                        lockedGroupName: groupEntity.name,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.kPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<GroupDetailsCubit, GroupDetailsState>(
            buildWhen: (_, __) => true,
            builder: (context, state) {
              if (state is GroupTasksLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is GroupTasksError) {
                return Center(
                  child: Text(
                    state.errMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              final cubit = context.read<GroupDetailsCubit>();
              final tasks = cubit.latestTasks;

              if (state is GroupTasksLoading && tasks.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (tasks.isEmpty) {
                return const Center(
                  child: Text(
                    "No tasks yet. Tap '+' to add one.",
                    style: TextStyle(color: AppColors.kColdGrey, fontSize: 13),
                  ),
                );
              }

              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TaskCard(
                      task: task,
                      onToggle: (value) {
                        cubit.toggleTask(task.id, value);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
