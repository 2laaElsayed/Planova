import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/TaskModel.dart';
import '../repositories/task_repository.dart';

enum TaskFilter { all, pending, done,upcoming }

class TasksProvider extends ChangeNotifier {
  final TaskRepository _repository;
  StreamSubscription<List<TaskModel>>? _subscription;

  List<TaskModel> _allTasks = [];
  TaskFilter _activeFilter = TaskFilter.all;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String? _error;

  TasksProvider(this._repository) {
    loadTasks();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  TaskFilter get activeFilter => _activeFilter;
  DateTime get selectedDate => _selectedDate;

  Map<String, List<TaskModel>> get groupedTasks {
    final filtered = _applyFilter();
    final Map<String, List<TaskModel>> groups = {};
    
    final today = DateTime.now();
    final realTodayStart = DateTime(today.year, today.month, today.day);

    for (final task in filtered) {
      final taskDay = DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
      
      bool isOverdue = taskDay.isBefore(realTodayStart) && task.status != 'done';

      String groupName = isOverdue ? "Overdue tasks" : task.taskType;
      
      groups.putIfAbsent(groupName, () => []).add(task);
    }

    final Map<String, List<TaskModel>> sortedGroups = {};
    if (groups.containsKey('Overdue tasks')) {
      sortedGroups['Overdue tasks'] = groups['Overdue tasks']!;
    }
    groups.forEach((key, value) {
      if (key != 'Overdue tasks') {
        sortedGroups[key] = value;
      }
    });

    return sortedGroups;
  }

 List<TaskModel> _applyFilter() {
    final selectedStart = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final today = DateTime.now();
    final realTodayStart = DateTime(today.year, today.month, today.day);
    switch (_activeFilter) {
      case TaskFilter.all:
        return _allTasks.where((t) {
          final taskDay = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
         bool isSameDay = taskDay.isAtSameMomentAs(selectedStart);
          bool isOverdue = taskDay.isBefore(realTodayStart) && t.status != 'done';
          
          return isSameDay || isOverdue;
        }).toList();

      case TaskFilter.pending:
        return _allTasks.where((t) {
          final taskDay = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
         bool isOverdue = taskDay.isBefore(selectedStart) && t.status != 'done';
        bool isTodayPending = taskDay.isAtSameMomentAs(selectedStart) && t.status != 'done';
    return isTodayPending || isOverdue;
        }).toList();

      case TaskFilter.done:
        return _allTasks.where((t) {
          final taskDay = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
          return taskDay.isAtSameMomentAs(selectedStart) && t.status == 'done';
        }).toList();

      case TaskFilter.upcoming:
        return _allTasks.where((t) {
          final taskDay = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
          return taskDay.isAfter(selectedStart) && t.status != 'done';
        }).toList();
    }
  }

  void loadTasks() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _subscription?.cancel();

    _subscription = _repository.watchUserTasks().listen(
      (tasks) {
        _allTasks = List.from(tasks);
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        print("Firestore Stream Error: $e"); 
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void changeFilter(TaskFilter filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<void> toggleTask(TaskModel task) async {
    try {
      await _repository.toggleTaskStatus(task);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _repository.deleteTask(taskId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}