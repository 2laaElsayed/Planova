import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/core/constants/app_styles.dart';
import 'package:planova_app/core/widgets/custom_button.dart';
import 'package:planova_app/core/widgets/custom_text_field.dart';
import 'package:planova_app/features/group/domain/entities/group_task_entity.dart';
import 'package:planova_app/features/group/presentation/manager/create_task_cubit/create_task_cubit.dart';
import 'package:planova_app/features/group/presentation/views/widgets/field_label.dart';
import 'package:planova_app/features/group/presentation/views/widgets/group_drop_down.dart';
import 'package:planova_app/features/group/presentation/views/widgets/priority_dropdown.dart';

class CreateTaskScaffold extends StatefulWidget {

  const CreateTaskScaffold({super.key, this.lockedGroupId, this.lockedGroupName, this.taskToEdit});
  final String? lockedGroupId;
  final String? lockedGroupName;
  final GroupTaskEntity? taskToEdit; 

  @override
  State<CreateTaskScaffold> createState() => _CreateTaskScaffoldState();
}

class _CreateTaskScaffoldState extends State<CreateTaskScaffold> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  TaskPriority _priority = TaskPriority.high;
  String? _selectedGroupId;
  String? _selectedGroupName;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  bool _reminderEnabled = false;

  bool get _isGroupLocked => widget.lockedGroupId != null;
  bool get _isEditMode => widget.taskToEdit != null;

  @override
  void initState() {
    super.initState();
    _selectedGroupId = widget.lockedGroupId;
    _selectedGroupName = widget.lockedGroupName;

  
    if (_isEditMode) {
      _titleController.text = widget.taskToEdit!.title;
      _descriptionController.text = widget.taskToEdit!.description;
      _priority = widget.taskToEdit!.priority;
      _dueDate = widget.taskToEdit!.dueDate;
    }

    if (!_isGroupLocked) {
      context.read<CreateTaskCubit>().loadAvailableGroups().then((_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _submit(BuildContext context) {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.logoutRed,
          content: Text("Title is required"),
        ),
      );
      return;
    }

    if (_selectedGroupId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.logoutRed,
          content: Text("Please select a group"),
        ),
      );
      return;
    }

    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final cubit = context.read<CreateTaskCubit>();

    if (_isEditMode) {
     
      cubit.updateTask(
        taskId: widget.taskToEdit!.id,
        groupId: _selectedGroupId!,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _priority,
        dueDate: _dueDate,
      );
    } else {
   
      cubit.createTask(
        groupId: _selectedGroupId!,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _priority,
        dueDate: _dueDate,
        createdByUid: currentUid,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackGround,
      appBar: AppBar(
        backgroundColor: AppColors.kBackGround,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios, color: AppColors.mediumGrey),
        ),
    
        title: Text(_isEditMode ? "Update Task" : "New Task", style: AppStyles.styleSemiBold18),
      ),
      body: BlocListener<CreateTaskCubit, CreateTaskState>(
        listener: (context, state) {
          if (state is CreateTaskSuccess) {
            Navigator.of(context).pop();
          }
          if (state is CreateTaskFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errMessage)),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(height: 8),
                      const FieldLabel("Title"),
                      const SizedBox(height: 6),
                      CustomTextField(
                        hintText: "What needs to be done?",
                        onchange: (_) {},
                        controller: _titleController,
                      ),
                      const SizedBox(height: 18),
                      const FieldLabel("Description"),
                      const SizedBox(height: 6),
                      CustomTextField(
                        hintText: "Add details...",
                        onchange: (_) {},
                        controller: _descriptionController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: PriorityDropdown(
                              value: _priority,
                              onChanged: (value) {
                                setState(() => _priority = value);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: BlocBuilder<CreateTaskCubit, CreateTaskState>(
                              builder: (context, state) {
                                final cubit = context.read<CreateTaskCubit>();
                                return GroupDropDown(
                                  isLocked: _isGroupLocked,
                                  lockedName: _selectedGroupName,
                                  groups: cubit.availableGroups,
                                  selectedGroupId: _selectedGroupId,
                                  onChanged: (groupId, groupName) {
                                    setState(() {
                                      _selectedGroupId = groupId;
                                      _selectedGroupName = groupName;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      GestureDetector(
                        onTap: _pickDueDate,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.kWhite,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.kStroke),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  size: 16, color: AppColors.kPrimary),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Due Date",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.kColdGrey,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('EEEE, MMM d, yyyy').format(_dueDate),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.kDarkBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.kWhite,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.kStroke),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.notifications_none,
                                size: 18, color: AppColors.kPrimary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Reminder",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.kDarkBlue,
                                    ),
                                  ),
                                  const Text(
                                    "Get notified before due date",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.kColdGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _reminderEnabled,
                              activeColor: AppColors.kPrimary,
                              onChanged: (value) {
                                setState(() => _reminderEnabled = value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<CreateTaskCubit, CreateTaskState>(
                  builder: (context, state) {
                    final isLoading = state is CreateTaskLoading;
                    return CustomButton(
                      onTap: isLoading ? null : () => _submit(context),
                      // 4. Dynamic Button Title
                      title: isLoading 
                          ? (_isEditMode ? "Updating..." : "Creating...") 
                          : (_isEditMode ? "Update Task" : "Create Task"),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}