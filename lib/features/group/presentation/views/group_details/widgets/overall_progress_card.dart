import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/features/group/presentation/manager/group_details_cubit/group_details_cubit.dart';

class OverallProgressCard extends StatelessWidget {
  const OverallProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupDetailsCubit, GroupDetailsState>(
      buildWhen: (_, __) => true,
      builder: (context, state) {
        final tasks = context.read<GroupDetailsCubit>().latestTasks;

        final completed = tasks.where((task) => task.isCompleted).length;

        final total = tasks.length;

        final progress = total == 0 ? 0.0 : completed / total;

        return Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.kStroke),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    'Overall Progress',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kDarkBlue,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${(progress * 100).round()}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kColdGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFEDF0F7),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.kLightBlue,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '$completed of $total tasks completed',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.kColdGrey,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${total - completed} remaining',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.kColdGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
