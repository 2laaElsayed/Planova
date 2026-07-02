import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planova_app/core/di/service_locator.dart';
import 'package:planova_app/features/group/domain/entities/group_task_entity.dart';
import 'package:planova_app/features/group/presentation/manager/create_task_cubit/create_task_cubit.dart';
import 'package:planova_app/features/group/presentation/views/widgets/create_task_scaffold.dart';

class CreateTaskView extends StatelessWidget {
  const CreateTaskView({
    super.key,
    this.lockedGroupId,
    this.lockedGroupName,
    this.taskToEdit, 
  });
  
  final String? lockedGroupId;
  final String? lockedGroupName;
  final GroupTaskEntity? taskToEdit; 

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = getIt<CreateTaskCubit>();
    
        return cubit;
      },
      child: CreateTaskScaffold(
        lockedGroupId: lockedGroupId,
        lockedGroupName: lockedGroupName,
        taskToEdit: taskToEdit,
      ),
    );
  }
}