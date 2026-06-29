import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tasks_provider.dart';
import '../providers/new_task_provider.dart';
import '../widgets/tasks_list_widgets/tasks_app_bar.dart';
import '../widgets/tasks_list_widgets/date_selector.dart';
import '../widgets/tasks_list_widgets/filter_tabs.dart';
import '../widgets/tasks_list_widgets/section_header.dart';
import '../widgets/tasks_list_widgets/task_card.dart';
import 'task_screen.dart';
import '../models/task_card_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TasksProvider>(
      builder: (context, provider, child) {
        final groupedTasks = provider.groupedTasks;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FE),
          body: SafeArea(
            child: Column(
              children: [
                TasksAppBar(
                  onAddPressed: () {
                    context.read<NewTaskProvider>().clearTask();

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
                  tabs: const ["All", "Pending", "Done", "Upcoming"],
                  initialIndex: provider.activeFilter.index,
                  onTabSelected: (index) {
                    provider.changeFilter(TaskFilter.values[index]);
                  },
                ),
                Expanded(
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.error != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Error loading tasks:\n${provider.error}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.only(bottom: 20),
                          children: [
                            ...groupedTasks.entries.map((entry) {
                              bool isOverdueSection =
                                  entry.key == 'Overdue tasks';

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SectionHeader(title: entry.key),
                                      if (isOverdueSection)
                                        const Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Icon(
                                            Icons.error_outline,
                                            color: Colors.redAccent,
                                            size: 22,
                                          ),
                                        ),
                                    ],
                                  ),

                                  ...entry.value.map((task) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12.0,
                                      ),
                                      child: Stack(
                                        children: [
                                          TaskCard(
                                            task: TaskCardModel.fromTaskModel(
                                              task,
                                            ),
                                            onToggle: () {
                                              provider.toggleTask(task);
                                            },
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      CreateTaskScreen(
                                                        isEdit: true,
                                                        task: task,
                                                      ),
                                                ),
                                              );
                                            },
                                          ),

                                          if (isOverdueSection)
                                            Positioned(
                                              left: 16,
                                              top: 4,
                                              bottom: 4,
                                              child: Container(
                                                width: 5,
                                                decoration: const BoxDecoration(
                                                  color: Colors.redAccent,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(12),
                                                        bottomLeft:
                                                            Radius.circular(12),
                                                      ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 16),
                                ],
                              );
                            }),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
