import 'package:flutter/material.dart';
import '../widgets/tasks_list_widgets/tasks_app_bar.dart';
import '../widgets/tasks_list_widgets/date_selector.dart';
import '../widgets/tasks_list_widgets/filter_tabs.dart';
import '../widgets/tasks_list_widgets/section_header.dart';
import '../widgets/tasks_list_widgets/task_card.dart';
import 'package:planova_app/features/tasks/models/task_card_model.dart';
import 'task_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<TaskCardModel> personalTasks = [
    TaskCardModel(
        title: "Morning meditation",
        date: "may 26",
        isCompleted: true,
        priority: TaskPriority.high),
    TaskCardModel(
        title: "Grocery shopping",
        date: "june 26",
        isCompleted: true,
        priority: TaskPriority.medium),
    TaskCardModel(
        title: "Read 30 pages",
        date: "july 26",
        isCompleted: false,
        priority: TaskPriority.low),
  ];

  final List<TaskCardModel> workTasks = [
    TaskCardModel(
        title: "Review pull requests",
        date: "april 26",
        isCompleted: true,
        priority: TaskPriority.high),
    TaskCardModel(
        title: "Team standup",
        date: "march 26",
        isCompleted: false,
        priority: TaskPriority.medium),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: Column(
          children: [
            TasksAppBar(
              onAddPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const CreateTaskScreen(isEdit: false),
                  ),
                );
              },
            ),

            const HorizontalDateSelector(),

            FilterTabs(
              tabs: const ["All", "Today", "Upcoming", "Done", "Priority"],
              initialIndex: 1,
              onTabSelected: (index) {
                // filter logic
              },
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 20),
                children: [
                  const SectionHeader(title: "Personal"),

                  ...personalTasks.map((task) => TaskCard(
                        task: task,
                        onToggle: () {
                          // toggle logic
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const CreateTaskScreen(isEdit: true),
                            ),
                          );
                        },
                      )),

                  const SizedBox(height: 16),

                  const SectionHeader(title: "Work"),

                  ...workTasks.map((task) => TaskCard(
                        task: task,
                        onToggle: () {
                          // toggle logic
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const CreateTaskScreen(isEdit: true),
                            ),
                          );
                        },
                      )),
                ],
              ),
            ),
          ],
        ),
      ),

      
    );
  }
}