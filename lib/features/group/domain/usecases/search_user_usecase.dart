import 'package:dartz/dartz.dart';
import 'package:planova_app/core/errors/failure.dart';
import 'package:planova_app/features/group/domain/entities/user_search_entity.dart';
import 'package:planova_app/features/group/domain/repos/groups_repo.dart';

class SearchUserUsecase {
  final GroupsRepo repo;

  SearchUserUsecase({required this.repo});

  Future<Either<Failure, UserSearchEntity>> call(String email) async {
    return await repo.searchUserByEmail(email);
  }
}