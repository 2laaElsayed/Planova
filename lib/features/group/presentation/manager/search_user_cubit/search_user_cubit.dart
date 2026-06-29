import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:planova_app/features/group/domain/entities/user_search_entity.dart';
import 'package:planova_app/features/group/domain/usecases/search_user_usecase.dart';

part 'search_user_state.dart';

class SearchUserCubit extends Cubit<SearchUserState> {
  final SearchUserUsecase searchUserUsecase;

  SearchUserCubit(this.searchUserUsecase) : super(SearchUserInitial());

  Future<void> searchUser(String email) async {
    if (email.trim().isEmpty) {
      emit(
        SearchUserFailure(
          errMessage: "Please enter the email of the user you want to add first.",
        ),
      );
      return;
    }
  
    emit(SearchUserLoading());

    final result = await searchUserUsecase.call(email);

    result.fold(
      (failure) => emit(SearchUserFailure(errMessage: failure.message)),
      (userEntity) {
        final currentUid = FirebaseAuth.instance.currentUser!.uid;
        if (userEntity.uid == currentUid) {
          emit(SearchUserFailure(errMessage: "You can't add yourself."));
        } else {
          emit(SearchUserSuccess(user: userEntity));
        }
      },
    );
  }

  void reset() => emit(SearchUserInitial());
}