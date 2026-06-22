import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/core/widgets/custom_button.dart';
import 'package:planova_app/features/group/data/models/group_item.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/presentation/manager/create_group_cubit/create_group_cubit.dart';
import 'package:planova_app/features/group/presentation/views/create_groups/widgets/appearance_body.dart';
import 'package:planova_app/features/group/presentation/views/create_groups/widgets/details_body.dart';
import 'package:planova_app/features/group/presentation/views/create_groups/widgets/members_body.dart';
import 'package:planova_app/features/group/presentation/views/create_groups/widgets/stepper_widget.dart';

class CreateGroupBody extends StatefulWidget {
  const CreateGroupBody({super.key, required this.groupType});

  final ScopeTab groupType;

  @override
  State<CreateGroupBody> createState() => _CreateGroupBodyState();
}

class _CreateGroupBodyState extends State<CreateGroupBody> {
  int currentStep = 0;
  final PageController _pageController = PageController();

  String groupName = '';
  String groupDescription = '';

  final List<Color> colors = [
    const Color(0xFFFFC1BE),
    const Color(0xFFF6E1D3),
    const Color(0xFFBEE7E9),
    const Color(0xFFFFF2CC),
    const Color(0xFFB9B4A1),
    const Color(0xFFE1D5FF),
    const Color(0xFFA8D1A9),
    const Color(0xFFF3C4D3),
    const Color(0xFFD9EDB4),
    const Color(0xFFE5D9C3),
  ];

  Color selectedColor = const Color(0xFFFFC1BE);

  void nextStep() {
    if (currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        currentStep++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateGroupCubit, CreateGroupState>(
      listener: (context, state) {
        if (state is CreateGroupSuccess) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Group created successfully ")),
          );
        }

        if (state is CreateGroupFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errMessage)));
        }
        if (state is CreateGroupLoading) {
          const Center(child: CircularProgressIndicator());
        }
      },

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            StepperWidget(currentStep: currentStep),

            const SizedBox(height: 40),

            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentStep = index;
                  });
                },
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: DetailsBody(
                      onNameChanged: (data) {
                        groupName = data;
                      },
                      onDesChanged: (data) {
                        groupDescription = data;
                      },
                    ),
                  ),

                  AppearanceBody(
                    colors: colors,
                    selectedColor: selectedColor,
                    onColorSelected: (color) {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    name: groupName,
                  ),

                  MembersBody(selectedColor: selectedColor, name: groupName),
                ],
              ),
            ),

            BlocBuilder<CreateGroupCubit, CreateGroupState>(
              builder: (context, state) {
                final isLoading = state is CreateGroupLoading;

                return CustomButton(
                  onTap: isLoading
                      ? null
                      : () {
                          if (currentStep == 2) {
                            BlocProvider.of<CreateGroupCubit>(
                              context,
                            ).createGroup(
                              GroupEntity(
                                groupId: '',
                                name: groupName,
                                description: groupDescription,
                                createdByUid:
                                    FirebaseAuth.instance.currentUser!.uid,
                                createdAt: DateTime.now(),
                                colorHex:
                                    '#${selectedColor.value.toRadixString(16).substring(2)}',
                                memberUids: [
                                  FirebaseAuth.instance.currentUser!.uid,
                                ],
                                status: GroupLife.active,
                                type: widget.groupType,
                              ),
                            );
                          } else {
                            if (groupName.isNotEmpty &&
                                groupDescription.isNotEmpty) {
                              nextStep();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.logoutRed,
                                  content: Text("This fields Required"),
                                ),
                              );
                            }
                          }
                        },
                  title: currentStep == 2
                      ? (isLoading ? "Creating..." : "Create Group")
                      : "Continue",
                );
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
