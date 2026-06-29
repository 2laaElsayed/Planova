import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tasks_provider.dart';

class HorizontalDateSelector extends StatefulWidget {
  const HorizontalDateSelector({super.key});

  @override
  State<HorizontalDateSelector> createState() => _HorizontalDateSelectorState();
}

class _HorizontalDateSelectorState extends State<HorizontalDateSelector> {
  late List<DateTime> _dates;

  @override
  void initState() {
    super.initState();
    _generateDates();
  }

  void _generateDates() {
    final today = DateTime.now();
    _dates = List.generate(
      30,
      (index) =>
          today.subtract(const Duration(days: 2)).add(Duration(days: index)),
    );
  }

  String _getWeekdayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final realToday = DateTime.now();

    return Consumer<TasksProvider>(
      builder: (context, provider, child) {
        final selectedDate = provider.selectedDate;

        return SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _dates.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final date = _dates[index];

              bool isSelected =
                  date.year == selectedDate.year &&
                  date.month == selectedDate.month &&
                  date.day == selectedDate.day;

              bool isRealToday =
                  date.year == realToday.year &&
                  date.month == realToday.month &&
                  date.day == realToday.day;

              return GestureDetector(
                onTap: () {
                  provider.selectDate(date);
                },
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.only(right: 12, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF9BA6FA) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      if (!isSelected)
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getWeekdayName(date.weekday),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isRealToday
                              ? (isSelected
                                    ? Colors.white
                                    : const Color(0xFF9BA6FA))
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
