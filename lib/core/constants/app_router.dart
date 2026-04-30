import 'package:go_router/go_router.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/GroupsScreen.dart';
import 'package:planova_app/features/group/presentation/views/create_groups/create_group_screen.dart';
import 'package:planova_app/features/group/presentation/views/edit_groups/edit_group_view.dart';
import 'package:planova_app/features/group/presentation/views/group_details/groups_details_view.dart';
import 'package:planova_app/features/auth/screens/sign_in_screen.dart';
import 'package:planova_app/features/auth/screens/sign_up_screen.dart';
import 'package:planova_app/features/auth/screens/reset_password_screen.dart';
import 'package:planova_app/features/main_page.dart';
import 'package:provider/provider.dart';
import 'package:planova_app/features/auth/providers/auth_provider.dart';
import 'package:planova_app/features/auth/screens/verify_code_screen.dart';
import 'package:planova_app/features/auth/screens/change_password_screen.dart';
import 'package:planova_app/features/tasks/screens/task_screen.dart';
import 'package:planova_app/features/tasks/screens/tasks_list_screen.dart';

abstract class AppRouter {
  // Auth
  static const String signIn = '/signIn';
  static const String signUp = '/signUp';
  static const String resetPassword = '/resetPassword';
  static const String verifyCode = '/verifyCode';
  static const String changePassword = '/changePassword';

  // Home
  static const String root = '/';

  // Groups
  static const String kCreateGroupView = '/CreateGroupView';
  static const String kGroupDetailsView = '/GroupDetailsView';
  static const String kEditGroupView = '/EditGroupView';
  static const String mainPage = '/MainPage';
  static final router = GoRouter(
    initialLocation: mainPage,

    redirect: (context, state) {
      final auth = Provider.of<AuthProvider>(context, listen: false);

      final isLoggedIn = auth.isLoggedIn;
      final location = state.uri.toString();

      final isAuthRoute =
          location == signIn ||
          location == signUp ||
          location == resetPassword ||
          location == verifyCode ||
          location == changePassword;

      if (!isLoggedIn && !isAuthRoute) {
        return mainPage;
      }

      if (isLoggedIn && isAuthRoute) {
        return root;
      }

      return null;
    },

    routes: [
      // Auth
      GoRoute(path: signIn, builder: (context, state) => const SignInScreen()),
      GoRoute(path: signUp, builder: (context, state) => const SignUpScreen()),
      GoRoute(
        path: resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: verifyCode,
        builder: (context, state) => const VerifyCodeScreen(),
      ),
      GoRoute(
        path: changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      //tasks screen
      GoRoute(
        path: '/tasksScreen',
        builder: (context, state) => const TasksScreen(),
      ),
      GoRoute(
        path: '/createTaskScreen',
        builder: (context, state) => const CreateTaskScreen(),
      ),
      GoRoute(path: mainPage, builder: (context, state) => const MainPage()),
      //Groups
      GoRoute(path: root, builder: (context, state) => const GroupsScreen()),
      GoRoute(
        path: kCreateGroupView,
        builder: (context, state) => const CreateGroupView(),
      ),
      GoRoute(
        path: kGroupDetailsView,
        builder: (context, state) => const GroupsDetailsView(),
      ),
      GoRoute(
        path: kEditGroupView,
        builder: (context, state) => const EditGroupView(),
      ),
    ],
  );
}
