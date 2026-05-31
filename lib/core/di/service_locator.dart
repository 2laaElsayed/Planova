import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:planova_app/features/group/data/repo/groups_repo_impl.dart';
import 'package:planova_app/features/group/data/service/groups_firebase_service.dart';
import 'package:planova_app/features/group/domain/repos/groups_repo.dart';
import 'package:planova_app/features/group/domain/usecases/create_group_usecase.dart';
import 'package:planova_app/features/group/domain/usecases/get_groups_usecase.dart';
import 'package:planova_app/features/group/presentation/manager/create_group_cubit/create_group_cubit.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Services
  getIt.registerLazySingleton<GroupsFirebaseService>(
    () => GroupsFirebaseServiceImpl(firestore: FirebaseFirestore.instance),
  );

  // Repos

  getIt.registerLazySingleton<GroupsRepo>(() => GroupsRepoImpl(getIt()));

  // UseCases
  getIt.registerLazySingleton(() => CreateGroupUsecase(repo: getIt()));
  getIt.registerLazySingleton(() => GetGroupsUsecase(repo: getIt()));

  // Cubit
  getIt.registerLazySingleton(() => CreateGroupCubit(getIt()));
}
