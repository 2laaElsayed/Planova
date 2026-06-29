import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/core/constants/app_styles.dart';
import 'package:planova_app/core/di/service_locator.dart';
import 'package:planova_app/features/group/data/models/group_model.dart'
    show GroupEntityUiX;
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/presentation/manager/create_group_cubit/create_group_cubit.dart';
import 'package:planova_app/features/group/presentation/manager/search_user_cubit/search_user_cubit.dart';
import 'package:planova_app/features/group/presentation/views/create_groups/widgets/members_body.dart';

class AddMembersView extends StatelessWidget {
  const AddMembersView({super.key, required this.groupEntity});
  final GroupEntity groupEntity;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<CreateGroupCubit>()),
        BlocProvider(create: (context) => getIt<SearchUserCubit>()),
        BlocProvider(create: (context) => getIt<SearchUserCubit>()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.kBackGround,
        appBar: AppBar(
          backgroundColor: AppColors.kBackGround,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios, color: AppColors.mediumGrey),
          ),
          title: Text("Add Members", style: AppStyles.styleSemiBold18),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: MembersBody(
              selectedColor: groupEntity.accentColor,
              name: groupEntity.name,
              groupId: groupEntity.groupId,
            ),
          ),
        ),
      ),
    );
  }
}
