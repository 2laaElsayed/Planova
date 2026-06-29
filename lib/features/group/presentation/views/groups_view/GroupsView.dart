import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planova_app/core/di/service_locator.dart';
import 'package:planova_app/features/group/presentation/manager/get_groups_cubit/get_groups_cubit.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/groups_screen_body.dart';

class GroupsView extends StatelessWidget {
  const GroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetGroupsCubit(getIt())..getGroups()),
      ],

      child: const Scaffold(
        // backgroundColor: Color.fromARGB(255, 184, 184, 224),
        body: SafeArea(child: GroupsScreenBody()),
      ),
    );
  }
}
