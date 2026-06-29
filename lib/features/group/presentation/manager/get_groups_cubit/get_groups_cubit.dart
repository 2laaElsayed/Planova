import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/domain/usecases/get_my_groups_usecase.dart';

part 'get_groups_state.dart';

class GetGroupsCubit extends Cubit<GetGroupsState> {
  GetGroupsCubit(this.getMyGroupsUseCase) : super(GetGroupsInitial());

  final GetMyGroupsUseCase getMyGroupsUseCase;

  Future<void> getGroups() async {
    emit(GetGroupsLoading());
    final returnedData = await getMyGroupsUseCase.call();
    returnedData.fold(
      (failure) => emit(GetGroupsFailure(errMessage: failure.message)),
      (data) => emit(GetGroupsSuccess(groups: data)),
    );
  }
}