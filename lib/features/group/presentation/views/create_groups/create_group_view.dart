import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/core/constants/app_styles.dart';
import 'package:planova_app/core/di/service_locator.dart';
import 'package:planova_app/features/group/data/models/group_item.dart';
import 'package:planova_app/features/group/presentation/manager/create_group_cubit/create_group_cubit.dart';
import 'package:planova_app/features/group/presentation/manager/search_user_cubit/search_user_cubit.dart';
import 'package:planova_app/features/group/presentation/views/create_groups/widgets/create_group_body.dart';

class CreateGroupView extends StatelessWidget {
  const CreateGroupView({super.key, required this.scopeTab});
  final ScopeTab scopeTab;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<CreateGroupCubit>()),
        BlocProvider(create: (context) => getIt<SearchUserCubit>()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.kBackGround,
        appBar: AppBar(
          backgroundColor: AppColors.kBackGround,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios, color: AppColors.mediumGrey),
          ),
          title: Text("Create Group", style: AppStyles.styleSemiBold18),
        ),
        body: SafeArea(child: CreateGroupBody(groupType: scopeTab)),
      ),
    );
  }
}