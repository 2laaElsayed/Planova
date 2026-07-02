import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planova_app/features/tasks/screens/task_screen.dart';
import 'package:provider/provider.dart'; 
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/presentation/manager/group_details_cubit/group_details_cubit.dart';
import 'package:planova_app/features/group/presentation/views/group_details/widgets/task_card.dart';

import 'package:planova_app/features/tasks/providers/new_task_provider.dart';
import 'package:planova_app/features/tasks/models/TaskModel.dart'; 

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
                  context.read<NewTaskProvider>().initForSpecificGroup(
                        groupEntity.groupId,
                        groupEntity.name,
                      );

                  
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CreateTaskScreen(isEdit: false),
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
                  final groupTask = tasks[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        // 3. MAP GroupTaskEntity to TaskModel for Editing
                        final taskModelToEdit = TaskModel(
                          taskId: groupTask.id,
                          title: groupTask.title,
                          description: groupTask.description,
                          priority: groupTask.priority.name, // Enum to string
                          groupId: groupTask.groupId,
                          groupName: groupEntity.name,
                          taskType: 'Team',
                          dueDate: groupTask.dueDate,
                          reminderEnabled: false,
                          status: groupTask.isCompleted ? 'done' : 'todo',
                          ownerUid: groupTask.createdByUid,
                          createdAt: groupTask.createdAt,
                        );

                 
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CreateTaskScreen(
                              isEdit: true,
                              task: taskModelToEdit,
                            ),
                          ),
                        );
                      },
                      child: TaskCard(
                        task: groupTask,
                        onToggle: (value) {
                          cubit.toggleTask(groupTask.id, value);
                        },
                      ),
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