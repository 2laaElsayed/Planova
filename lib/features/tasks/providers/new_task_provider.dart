import 'package:flutter/foundation.dart';
import '../models/TaskModel.dart';
import '../repositories/task_repository.dart';

enum NewTaskStatus { editing, submitting, success, error }

class NewTaskProvider extends ChangeNotifier {
  final TaskRepository _repository;
  String _originalOwnerUid = '';
  DateTime _originalCreatedAt = DateTime.now();

  String title = '';
  String description = '';
  String priority = 'medium';
  String? groupId;
  String taskType = 'Personal';
  DateTime dueDate = DateTime.now();
  bool reminderEnabled = false;

  NewTaskStatus _status = NewTaskStatus.editing;
  String? _error;

  NewTaskProvider(this._repository);

  NewTaskStatus get status => _status;
  String? get error => _error;
  bool get isSubmitting => _status == NewTaskStatus.submitting;
  bool get isValid => title.trim().isNotEmpty;

  void setTitle(String value) {
    title = value;
    notifyListeners();
  }

  void setDescription(String value) {
    description = value;
    notifyListeners();
  }

  void setPriority(String value) {
    priority = value;
    notifyListeners();
  }

  void setGroup(String? id, String type) {
    groupId = id;
    taskType = type;
    notifyListeners();
  }

  void setDueDate(DateTime date) {
    dueDate = date;
    notifyListeners();
  }

  void toggleReminder(bool value) {
    reminderEnabled = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    _status = NewTaskStatus.editing;
    notifyListeners();
  }

  Future<void> submitTask() async {
    if (!isValid) {
      _error = 'Title cannot be empty';
      _status = NewTaskStatus.error;
      notifyListeners();
      return;
    }

    _status = NewTaskStatus.submitting;
    _error = null;
    notifyListeners();

    try {
      final task = TaskModel(
        taskId: '',
        title: title.trim(),
        description: description.trim(),
        priority: priority,
        groupId: groupId,
        taskType: taskType,
        dueDate: dueDate,
        reminderEnabled: reminderEnabled,
        status: 'todo',
        ownerUid: '',
        createdAt: DateTime.now(),
      );
      await _repository.createTask(task);
      _status = NewTaskStatus.success;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _status = NewTaskStatus.error;
      notifyListeners();
    }
  }

  void loadTask(TaskModel task) {
    title = task.title;
    description = task.description;
    priority = task.priority;
    groupId = task.groupId;
    taskType = task.taskType;
    dueDate = task.dueDate;
    reminderEnabled = task.reminderEnabled;

    _originalOwnerUid = task.ownerUid;
    _originalCreatedAt = task.createdAt;

    _status = NewTaskStatus.editing;
    notifyListeners();
  }

  Future<void> updateTask(String taskId) async {
    if (!isValid) {
      _error = 'Title cannot be empty';
      _status = NewTaskStatus.error;
      notifyListeners();
      return;
    }

    _status = NewTaskStatus.submitting;
    _error = null;
    notifyListeners();

    try {
      final task = TaskModel(
        taskId: taskId,
        title: title.trim(),
        description: description.trim(),
        priority: priority,
        groupId: groupId,
        taskType: taskType,
        dueDate: dueDate,
        reminderEnabled: reminderEnabled,
        status: 'todo',
        ownerUid: _originalOwnerUid,
        createdAt: _originalCreatedAt,
      );

      await _repository.updateTask(task);
      _status = NewTaskStatus.success;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _status = NewTaskStatus.error;
      notifyListeners();
    }
  }

  void clearTask() {
    title = '';
    description = '';
    priority = 'medium';
    groupId = null;
    taskType = 'Personal';
    dueDate = DateTime.now();
    reminderEnabled = false;

    _status = NewTaskStatus.editing;
    _error = null;
    notifyListeners();
  }
}
