import 'package:go_router/go_router.dart';
import 'package:planova_app/features/group/data/models/group_item.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/GroupsView.dart';
import 'package:planova_app/features/group/presentation/views/create_groups/create_group_view.dart';
import 'package:planova_app/features/group/presentation/views/edit_groups/edit_group_view.dart';
import 'package:planova_app/features/group/presentation/views/group_details/groups_details_view.dart';
import 'package:planova_app/features/auth/screens/sign_in_screen.dart';
import 'package:planova_app/features/auth/screens/sign_up_screen.dart';
import 'package:planova_app/features/auth/screens/reset_password_screen.dart';
import 'package:planova_app/features/main_page.dart';
import 'package:planova_app/features/auth/providers/auth_provider.dart';
import 'package:planova_app/features/auth/screens/verify_code_screen.dart';
<<<<<<< HEAD
import 'package:planova_app/features/settings/screens/change_password_screen.dart';
=======
import 'package:planova_app/features/auth/screens/change_password_screen.dart';
import 'package:planova_app/features/splash/presentation/views/splash_view.dart';
import 'package:planova_app/features/tasks/models/TaskModel.dart';
>>>>>>> main
import 'package:planova_app/features/tasks/screens/task_screen.dart';
import 'package:planova_app/features/tasks/screens/tasks_list_screen.dart';

abstract class AppRouter {
  static const String splash = '/splash';
  static const String signIn = '/signIn';
  static const String signUp = '/signUp';
  static const String resetPassword = '/resetPassword';
  static const String verifyCode = '/verifyCode';
  static const String changePassword = '/changePassword';
  static const String root = '/';
  static const String createTaskScrren = '/CreateTaskScreen';
  static const String tasksListScreen = '/TasksScreen';
  static const String kGroupsScreen = '/groupsScreen';
  static const String kCreateGroupView = '/CreateGroupView';
  static const String kGroupDetailsView = '/GroupDetailsView';
  static const String kEditGroupView = '/EditGroupView';

  static GoRouter router(AuthProvider authProvider) {
    return GoRouter(
      refreshListenable: authProvider,
      // 1. Start the app at the sign-in screen
      initialLocation: splash,
      redirect: (context, state) {
        final isLoggedIn = authProvider.isLoggedIn;
        final isEmailVerified = authProvider.isEmailVerified;
        final location = state.uri.toString();
        if (location == splash) return null;
        final isAuthRoute =
            location == signIn ||
            location == signUp ||
            location == resetPassword ||
            location == verifyCode;

        // 2. Uncommented the guard clauses to handle auth state routing
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
        GoRoute(path: splash, builder: (context, state) => const SplashView()),
        GoRoute(
          path: signIn,
          builder: (context, state) => const SignInScreen(),
        ),
        GoRoute(
          path: signUp,
          builder: (context, state) => const SignUpScreen(),
        ),
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
        GoRoute(path: root, builder: (context, state) => const MainPage()),
        GoRoute(
          path: '/tasksScreen',
          builder: (context, state) => const TasksScreen(),
        ),
        GoRoute(
          path: '/createTaskScreen',
          builder: (context, state) => const CreateTaskScreen(),
        ),
        GoRoute(
          path: kGroupsScreen,
          builder: (context, state) => const GroupsView(),
        ),
        GoRoute(
          path: kCreateGroupView,
          builder: (context, state) {
            // Make sure ScopeTab is imported or defined in your file!
            final type = state.extra as ScopeTab;
            return CreateGroupView(scopeTab: type);
          },
        ),
        GoRoute(
          path: kGroupDetailsView,
          builder: (context, state) {
            final group = state.extra as GroupEntity;
            return GroupsDetailsView(groupEntity: group);
          },
        ),
        GoRoute(
          path: kEditGroupView,
          builder: (context, state) => const EditGroupView(),
        ),
        GoRoute(
          path: tasksListScreen,
          builder: (context, state) {
            return TasksScreen();
          },
        ),
      ],
    );
  }
}
