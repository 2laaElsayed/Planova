import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:planova_app/features/group/data/repo/groups_repo_impl.dart';
import 'package:planova_app/features/group/data/service/groups_firebase_service.dart';
import 'package:planova_app/features/group/domain/repos/groups_repo.dart';
import 'package:planova_app/features/group/domain/usecases/Getgroup_tasks_stream_usecase.dart';

import 'package:planova_app/features/group/domain/usecases/create_group_usecase.dart';
import 'package:planova_app/features/group/domain/usecases/get_group_members_usecase.dart';
import 'package:planova_app/features/group/domain/usecases/get_groups_usecase.dart';
import 'package:planova_app/features/group/domain/usecases/get_my_groups_usecase.dart';
import 'package:planova_app/features/group/domain/usecases/remove_member_usecase.dart';
import 'package:planova_app/features/group/domain/usecases/search_user_usecase.dart';
import 'package:planova_app/features/group/domain/usecases/add_member_to_existing_group_usecase.dart';
import 'package:planova_app/features/group/domain/usecases/create_group_task_usecase.dart';
import 'package:planova_app/features/group/domain/usecases/get_chat_messages_stream_usecase.dart';
import 'package:planova_app/features/group/domain/usecases/send_group_message_usecase.dart';
import 'package:planova_app/features/group/domain/usecases/toggle_task_completion_usecase.dart';

import 'package:planova_app/features/group/presentation/manager/create_group_cubit/create_group_cubit.dart';
import 'package:planova_app/features/group/presentation/manager/create_task_cubit/create_task_cubit.dart';
import 'package:planova_app/features/group/presentation/manager/get_groups_cubit/get_groups_cubit.dart';
import 'package:planova_app/features/group/presentation/manager/group_member_cubit/group_members_cubit.dart';
import 'package:planova_app/features/group/presentation/manager/search_user_cubit/search_user_cubit.dart';
import 'package:planova_app/features/group/presentation/manager/group_details_cubit/group_details_cubit.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  getIt.registerLazySingleton<GroupsFirebaseService>(
    () => GroupsFirebaseServiceImpl(firestore: FirebaseFirestore.instance),
  );
  getIt.registerLazySingleton<GroupsRepo>(() => GroupsRepoImpl(getIt()));

  getIt.registerLazySingleton(() => CreateGroupUsecase(repo: getIt()));
  getIt.registerLazySingleton(() => GetGroupsUsecase(repo: getIt()));
  getIt.registerLazySingleton(() => SearchUserUsecase(repo: getIt()));
  getIt.registerLazySingleton(() => GetGroupMembersUsecase(repo: getIt()));
  getIt.registerLazySingleton(() => RemoveMemberUsecase(repo: getIt()));

  getIt.registerLazySingleton(() => GetMyGroupsUseCase(repo: getIt()));
  getIt.registerLazySingleton(
    () => AddMemberToExistingGroupUseCase(repo: getIt()),
  );
  getIt.registerLazySingleton(() => CreateGroupTaskUseCase(repo: getIt()));
  getIt.registerLazySingleton(
    () => GetChatMessagesStreamUseCase(repo: getIt()),
  );
  getIt.registerLazySingleton(() => GetGroupTasksStreamUseCase(repo: getIt()));
  getIt.registerLazySingleton(() => SendGroupMessageUseCase(repo: getIt()));
  getIt.registerLazySingleton(() => ToggleTaskCompletionUseCase(repo: getIt()));


  getIt.registerFactory(() => GetGroupsCubit(getIt<GetMyGroupsUseCase>()));

  getIt.registerFactory(() => SearchUserCubit(getIt<SearchUserUsecase>()));

  getIt.registerFactory(
    () => CreateGroupCubit(
      getIt<CreateGroupUsecase>(),
      addMemberToExistingGroupUsecase: getIt<AddMemberToExistingGroupUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => GroupMembersCubit(
      getGroupMembersUsecase: getIt(),
      removeMemberUsecase: getIt(),
      addMemberToExistingGroupUsecase: getIt<AddMemberToExistingGroupUseCase>(),
    ),
  );

  getIt.registerFactoryParam<GroupDetailsCubit, String, void>(
    (groupId, _) => GroupDetailsCubit(
      groupId: groupId,
      getGroupTasksStreamUseCase: getIt(),
      getChatMessagesStreamUseCase: getIt(),
      sendGroupMessageUseCase: getIt(),
      createGroupTaskUseCase: getIt(),
      toggleTaskCompletionUseCase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => CreateTaskCubit(
      createGroupTaskUseCase: getIt<CreateGroupTaskUseCase>(),
      getMyGroupsUseCase: getIt<GetMyGroupsUseCase>(),
    ),
  );
}
