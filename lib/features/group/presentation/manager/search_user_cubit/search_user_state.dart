part of 'search_user_cubit.dart';

@immutable
abstract class SearchUserState {}

class SearchUserInitial extends SearchUserState {}

class SearchUserLoading extends SearchUserState {}

class SearchUserSuccess extends SearchUserState {
  final UserSearchEntity user;
  SearchUserSuccess({required this.user});
}

class SearchUserFailure extends SearchUserState {
  final String errMessage;
  SearchUserFailure({required this.errMessage});
}