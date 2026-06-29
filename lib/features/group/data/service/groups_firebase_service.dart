import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:planova_app/core/errors/failure.dart';
import 'package:planova_app/features/group/data/models/group_message_model.dart';
import 'package:planova_app/features/group/data/models/group_model.dart';
import 'package:planova_app/features/group/data/models/group_task_model.dart';
import 'package:planova_app/features/group/data/models/member_model.dart';
import 'package:planova_app/features/group/data/models/user_search_model.dart';

abstract class GroupsFirebaseService {
  Future<Either<Failure, void>> createGroup(GroupModel group);
  Future<Either<Failure, List<GroupModel>>> getGroups();
  Future<Either<Failure, UserSearchModel>> searchUserByEmail(String email);
  Future<Either<Failure, List<GroupMemberModel>>> getGroupMembers(
    String groupId,
  );
  Future<Either<Failure, void>> removeMemberFromGroup(
    String groupId,
    String memberUid,
  );
  Future<Either<Failure, void>> addMemberToExistingGroup({
    required String groupId,
    required String uid,
    required String name,
    required String email,
    String? avatarUrl,
  });
  Future<Either<Failure, void>> createGroupTask(GroupTaskModel task);
  Future<Either<Failure, List<GroupTaskModel>>> getGroupTasks(String groupId);
  Stream<List<GroupTaskModel>> streamGroupTasks(String groupId);
  Future<Either<Failure, void>> toggleTaskCompletion({
    required String groupId,
    required String taskId,
    required bool isCompleted,
  });
  Future<Either<Failure, void>> sendGroupMessage(
    GroupMessageModel message, {
    required String groupId,
  });
  Stream<List<GroupMessageModel>> getChatMessagesStream(String groupId);
}
////////////////////////////////////////////////////////////////////////////////////
class GroupsFirebaseServiceImpl implements GroupsFirebaseService {
  final FirebaseFirestore firestore;
  GroupsFirebaseServiceImpl({required this.firestore});

  String get _currentUid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No authenticated user found.");
    }
    return user.uid;
  }
  @override
  Future<Either<Failure, void>> createGroup(GroupModel group) async {
    try {
      final currentUid = _currentUid;
      final currentUserDoc = await firestore
          .collection('users')
          .doc(currentUid)
          .get();
      final currentUserData = currentUserDoc.data() ?? {};
      final docRef = firestore.collection('groups').doc();
      final finalGroup = group.copyWith(
        groupId: docRef.id,
        createdByUid: currentUid,
        memberUids: {currentUid, ...group.memberUids}.toList(),
      );
      final Map<String, Map<String, dynamic>> resolvedUsers = {};
      final invitedUids = finalGroup.memberUids.where(
        (uid) => uid != currentUid,
      );
      for (final uid in invitedUids) {
        final userSnap = await firestore.collection('users').doc(uid).get();
        resolvedUsers[uid] = userSnap.data() ?? {};
      }
      final batch = firestore.batch();
      batch.set(docRef, finalGroup.toMap());
      final adminMember = GroupMemberModel(
        uid: currentUid,
        name:
            currentUserData['full_name'] ?? currentUserData['name'] ?? 'Admin',
        email: currentUserData['email'] ?? '',
        avatarUrl: currentUserData['avatar_url'],
        role: 'admin',
        joinedAt: DateTime.now(),
      );
      batch.set(
        docRef.collection('members').doc(currentUid),
        adminMember.toMap(),
      );
      for (final uid in invitedUids) {
        final userData = resolvedUsers[uid] ?? {};
        final member = GroupMemberModel(
          uid: uid,
          name: userData['full_name'] ?? userData['name'] ?? 'Unknown Member',
          email: userData['email'] ?? '',
          avatarUrl: userData['avatar_url'],
          role: 'member',
          joinedAt: DateTime.now(),
        );
        batch.set(docRef.collection('members').doc(uid), member.toMap());
      }
      await batch.commit();
      return right(null);
    } catch (e) {
      log(e.toString());
      return left(Failure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, List<GroupModel>>> getGroups() async {
    try {
      final currentUid = _currentUid;
      final returnedData = await firestore
          .collection('groups')
          .where('member_uids', arrayContains: currentUid)
          .get();

      final groups = returnedData.docs
          .map((e) => GroupModel.fromJson(e.data()))
          .toList();
      return right(groups);
    } catch (e) {
      log(e.toString());
      return left(Failure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, UserSearchModel>> searchUserByEmail(
    String email,
  ) async {
    try {
      final querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: email.trim())
          .limit(1)
          .get();
      if (querySnapshot.docs.isEmpty) {
        return left(Failure("This user not exist !!!"));
      }
      final doc = querySnapshot.docs.first;
      final userModel = UserSearchModel.fromJson(doc.data(), doc.id);
      return right(userModel);
    } catch (e) {
      log(e.toString());
      return left(Failure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, List<GroupMemberModel>>> getGroupMembers(
    String groupId,
  ) async {
    try {
      final membersSnapshot = await firestore
          .collection('groups')
          .doc(groupId)
          .collection('members')
          .orderBy('joinedAt', descending: false)
          .get();
      final membersList = membersSnapshot.docs
          .map((doc) => GroupMemberModel.fromMap(doc.data(), doc.id))
          .toList();

      return right(membersList);
    } catch (e) {
      log(e.toString());
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeMemberFromGroup(
    String groupId,
    String memberUid,
  ) async {
    try {
      final batch = firestore.batch();

      final memberDocRef = firestore
          .collection('groups')
          .doc(groupId)
          .collection('members')
          .doc(memberUid);
      batch.delete(memberDocRef);

      final groupDocRef = firestore.collection('groups').doc(groupId);
      batch.update(groupDocRef, {
        'member_uids': FieldValue.arrayRemove([memberUid]),
      });

      await batch.commit();
      return right(null);
    } catch (e) {
      log(e.toString());
      return left(Failure(e.toString()));
    }
  }

  @override
Future<Either<Failure, void>> addMemberToExistingGroup({
  required String groupId,
  required String uid,
  required String name,
  required String email,
  String? avatarUrl,
}) async {
  try {
    final groupDocRef = firestore.collection('groups').doc(groupId);

    final existingMember = await groupDocRef
        .collection('members')
        .doc(uid)
        .get();

    if (existingMember.exists) {
      return left(
        Failure("This member is already in the group."),
      );
    }

    final member = GroupMemberModel(
      uid: uid,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      role: 'member',
      joinedAt: DateTime.now(),
    );

    final batch = firestore.batch();

    batch.set(
      groupDocRef.collection('members').doc(uid),
      member.toMap(),
    );

    batch.update(groupDocRef, {
      'member_uids': FieldValue.arrayUnion([uid]),
    });

    await batch.commit();

    return right(null);
  } catch (e) {
    log(e.toString());
    return left(Failure(e.toString()));
  }
}
  @override
  Future<Either<Failure, void>> createGroupTask(GroupTaskModel task) async {
    try {
      final taskDocRef = firestore
          .collection('groups')
          .doc(task.groupId)
          .collection('tasks')
          .doc();
      final finalTask = GroupTaskModel(
        id: taskDocRef.id,
        groupId: task.groupId,
        title: task.title,
        description: task.description,
        priority: task.priority,
        dueDate: task.dueDate,
        isCompleted: task.isCompleted,
        createdByUid: task.createdByUid,
        createdAt: DateTime.now(),
      );

      await taskDocRef.set(finalTask.toMap());
      return right(null);
    } catch (e) {
      log(e.toString());
      return left(Failure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, List<GroupTaskModel>>> getGroupTasks(
    String groupId,
  ) async {
    try {
      final snapshot = await firestore
          .collection('groups')
          .doc(groupId)
          .collection('tasks')
          .orderBy('dueDate', descending: false)
          .get();

      final tasks = snapshot.docs
          .map((doc) => GroupTaskModel.fromMap(doc.data(), doc.id, groupId))
          .toList();

      return right(tasks);
    } catch (e) {
      log(e.toString());
      return left(Failure(e.toString()));
    }
  }
  @override
  Stream<List<GroupTaskModel>> streamGroupTasks(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('tasks')
        .orderBy('dueDate', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => GroupTaskModel.fromMap(doc.data(), doc.id, groupId))
              .toList(),
        );
  }
  @override
  Future<Either<Failure, void>> toggleTaskCompletion({
    required String groupId,
    required String taskId,
    required bool isCompleted,
  }) async {
    try {
      await firestore
          .collection('groups')
          .doc(groupId)
          .collection('tasks')
          .doc(taskId)
          .update({'isCompleted': isCompleted});
      return right(null);
    } catch (e) {
      log(e.toString());
      return left(Failure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, void>> sendGroupMessage(
    GroupMessageModel message, {
    required String groupId,
  }) async {
    try {
      final chatDocRef = firestore
          .collection('groups')
          .doc(groupId)
          .collection('chats')
          .doc();

      await chatDocRef.set({
        ...message.toMap(),
        'timestamp': FieldValue.serverTimestamp(),
      });
      return right(null);
    } catch (e) {
      log(e.toString());
      return left(Failure(e.toString()));
    }
  }
  @override
  Stream<List<GroupMessageModel>> getChatMessagesStream(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => GroupMessageModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
