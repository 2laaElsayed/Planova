import 'package:dartz/dartz.dart';
import 'package:planova_app/core/errors/failure.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';

abstract class GroupsRepo {
  Future<Either<Failure, void>> createGroup(GroupEntity group);
  Future<Either<Failure, List<GroupEntity>>> getGroups();
}
