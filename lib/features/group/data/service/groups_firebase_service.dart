import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:planova_app/core/errors/failure.dart';
import 'package:planova_app/features/group/data/models/group_model.dart';

abstract class GroupsFirebaseService {
  Future<Either<Failure, void>> createGroup(GroupModel group);
  Future<Either<Failure, List<GroupModel>>> getGroups();
}

class GroupsFirebaseServiceImpl implements GroupsFirebaseService {
  final FirebaseFirestore firestore;

  GroupsFirebaseServiceImpl({required this.firestore});
  @override
  Future<Either<Failure, void>> createGroup(GroupModel group) async {
    try {
      final docRef = firestore.collection('groups').doc();

      final newGroup = group.copyWith(groupId: docRef.id);

      await docRef.set(newGroup.toMap());
      return right(null);
    } catch (e) {
      log(e.toString());

      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GroupModel>>> getGroups() async {
    try {
      final returnedData = await firestore.collection('groups').get();
      log(returnedData.docs.first.data().toString());
      final groups = returnedData.docs
          .map((e) => GroupModel.fromJson(e.data()))
          .toList();
      return right(groups);
    } catch (e) {
        log(e.toString());
      return left(Failure(e.toString()));
    }
  }
}
