import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/domain/usecases/create_group_usecase.dart';

part 'create_group_state.dart';

class CreateGroupCubit extends Cubit<CreateGroupState> {
  CreateGroupCubit(this.createGroupUsecase) : super(CreateGroupInitial());
  final CreateGroupUsecase createGroupUsecase;
  Future createGroup(GroupEntity group) async {
    emit(CreateGroupLoading());
    final returnedData = await createGroupUsecase.createGroup(group);
    returnedData.fold(
      (messege) => emit(CreateGroupFailure(errMessage: messege.toString())),
      (data) => emit(CreateGroupSuccess()),
    );
  }
}
