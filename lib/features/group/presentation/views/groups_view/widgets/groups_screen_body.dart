import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/features/group/data/models/group_item.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/presentation/manager/get_groups_cubit/get_groups_cubit.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/groups_activity_chips.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/groups_grid_view.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/groups_header.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/groups_list_view.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/groups_scope_tabs.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/groups_search_row.dart';

class GroupsScreenBody extends StatefulWidget {
  const GroupsScreenBody({super.key});

  @override
  State<GroupsScreenBody> createState() => _GroupsScreenBodyState();
}

class _GroupsScreenBodyState extends State<GroupsScreenBody> {
  ViewMode _mode = ViewMode.list;
  ScopeTab _scope = ScopeTab.all;
  ActivityFilter _activity = ActivityFilter.all;
  String _query = '';
  List<GroupEntity> filterGroups(List<GroupEntity> groups) {
    return groups.where((g) {
      final q = _query.trim().toLowerCase();

      final byQuery = q.isEmpty || g.name.toLowerCase().contains(q);

      final byScope = switch (_scope) {
        ScopeTab.all => true,
        ScopeTab.team => g.type == ScopeTab.team,
        ScopeTab.personal => g.type == ScopeTab.personal,
      };

      final byActivity = switch (_activity) {
        ActivityFilter.all => true,
        ActivityFilter.active => g.status == GroupLife.active,
        ActivityFilter.completed => g.status == GroupLife.completed,
        ActivityFilter.archived => g.status == GroupLife.archived,
      };

      return byQuery && byScope && byActivity;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackGround,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GroupsHeader(
                mode: _mode,
                onModeChange: (m) => setState(() => _mode = m),
              ),
              const SizedBox(height: 16),
              GroupsSearchRow(onSearch: (v) => setState(() => _query = v)),
              const SizedBox(height: 16),
              GroupsScopeTabs(
                selected: _scope,
                onChange: (s) => setState(() => _scope = s),
              ),
              const SizedBox(height: 16),
              GroupsActivityChips(
                selected: _activity,
                onChange: (a) => setState(() => _activity = a),
              ),
              const SizedBox(height: 8),
              BlocBuilder<GetGroupsCubit, GetGroupsState>(
                builder: (context, state) {
                  if (state is GetGroupsLoading) {
                    return Expanded(
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    );
                  } else if (state is GetGroupsSuccess) {
                    final filteredGroups = filterGroups(state.groups);

                    return Expanded(
                      child: filteredGroups.isEmpty
                          ? const Center(child: Text('No groups found'))
                          : AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              child: _mode == ViewMode.list
                                  ? GroupsListView(groups: filteredGroups)
                                  : GroupsGridView(groups: filteredGroups),
                            ),
                    );
                  }
                  return SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
