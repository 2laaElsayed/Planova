import 'package:go_router/go_router.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/GroupsScreen.dart';
import 'package:planova_app/features/group/presentation/views/create_groups/create_group_screen.dart';
import 'package:planova_app/features/group/presentation/views/edit_groups/edit_group_view.dart';
import 'package:planova_app/features/group/presentation/views/group_details/groups_details_view.dart';
import 'package:planova_app/features/auth/screens/sign_in_screen.dart';
import 'package:planova_app/features/auth/screens/sign_up_screen.dart';
import 'package:planova_app/features/auth/screens/reset_password_screen.dart';
import 'package:planova_app/features/main_page.dart';
import 'package:planova_app/features/auth/providers/auth_provider.dart';
import 'package:planova_app/features/auth/screens/verify_code_screen.dart';
import 'package:planova_app/features/settings/screens/change_password_screen.dart';
import 'package:planova_app/features/tasks/screens/task_screen.dart';
import 'package:planova_app/features/tasks/screens/tasks_list_screen.dart';

abstract class AppRouter {
  static const String signIn = '/signIn';
  static const String signUp = '/signUp';
  static const String resetPassword = '/resetPassword';
  static const String verifyCode = '/verifyCode';
  static const String changePassword = '/changePassword';
  static const String root = '/';
  static const String kGroupsScreen = '/groupsScreen';
  static const String kCreateGroupView = '/CreateGroupView';
  static const String kGroupDetailsView = '/GroupDetailsView';
  static const String kEditGroupView = '/EditGroupView';

  static GoRouter router(AuthProvider authProvider) {
    return GoRouter(
      refreshListenable: authProvider,
      initialLocation: signIn,
      redirect: (context, state) {
        final isLoggedIn = authProvider.isLoggedIn;
        final isEmailVerified = authProvider.isEmailVerified;
        final location = state.uri.toString();

        final isAuthRoute =
            location == signIn ||
            location == signUp ||
            location == resetPassword ||
            location == verifyCode;

        if (!isLoggedIn) {
        
          if (location == changePassword) return signIn;
          return isAuthRoute ? null : signIn;
        }

        if (isLoggedIn && !isEmailVerified) {
          return location == verifyCode ? null : verifyCode;
        }

        if (isLoggedIn && isEmailVerified && isAuthRoute) {
          return root;
        }

        return null;
      },
      routes: [
        GoRoute(path: signIn, builder: (context, state) => const SignInScreen()),
        GoRoute(path: signUp, builder: (context, state) => const SignUpScreen()),
        GoRoute(path: resetPassword, builder: (context, state) => const ResetPasswordScreen()),
        GoRoute(path: verifyCode, builder: (context, state) => const VerifyCodeScreen()),
        GoRoute(path: changePassword, builder: (context, state) => const ChangePasswordScreen()),
        GoRoute(path: root, builder: (context, state) => const MainPage()),
        GoRoute(path: '/tasksScreen', builder: (context, state) => const TasksScreen()),
        GoRoute(path: '/createTaskScreen', builder: (context, state) => const CreateTaskScreen()),
        GoRoute(path: kGroupsScreen, builder: (context, state) => const GroupsScreen()),
        GoRoute(path: kCreateGroupView, builder: (context, state) => const CreateGroupView()),
        GoRoute(path: kGroupDetailsView, builder: (context, state) => const GroupsDetailsView()),
        GoRoute(path: kEditGroupView, builder: (context, state) => const EditGroupView()),
      ],
    );
  }
}
