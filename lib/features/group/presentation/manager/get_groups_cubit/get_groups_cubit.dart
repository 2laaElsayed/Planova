import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/domain/usecases/get_groups_usecase.dart';

part 'get_groups_state.dart';

class GetGroupsCubit extends Cubit<GetGroupsState> {
  GetGroupsCubit(this.getGroupsUsecase) : super(GetGroupsInitial());
  final GetGroupsUsecase getGroupsUsecase;
  Future getGroups() async {
    emit(GetGroupsLoading());
    final returnedData = await getGroupsUsecase.getGroups();
    returnedData.fold(
      (errMessage) => emit(GetGroupsFailure(errMessage: errMessage.toString())),
      (data) => emit(GetGroupsSuccess(groups: data)),
    );
  }
}
