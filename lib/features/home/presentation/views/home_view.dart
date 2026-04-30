import 'package:flutter/material.dart';
import 'package:planova_app/features/home/presentation/views/widgets/custom_app_bar.dart';
import 'package:planova_app/features/home/presentation/views/widgets/task_overview_section.dart';
import 'package:planova_app/features/home/presentation/views/widgets/today_progress_card.dart';
import 'package:planova_app/features/home/presentation/views/widgets/todays_tasks_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                CustomAppBar(),
                SizedBox(height: 24),
                TodayProgressCard(),
                SizedBox(height: 24),
                TodaysTasksSection(),
                SizedBox(height: 24),
                TaskOverviewSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
