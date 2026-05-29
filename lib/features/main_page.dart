import 'package:flutter/material.dart';
import 'package:planova_app/features/tasks/screens/tasks_list_screen.dart';
import '../core/widgets/custom_bottom_nav_bar.dart';
import 'package:planova_app/features/home/presentation/views/home_view.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/GroupsScreen.dart';
import 'package:planova_app/features/settings/screens/settings_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeView(),
    TasksScreen(),
    GroupsScreen(),
    SettingsScreen(),
  ];

  void onTap(int index) {
    setState(() => currentIndex = index);
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int index) {
    setState(() => currentIndex = index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}
