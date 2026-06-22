import 'package:flutter/material.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/features/group/data/models/group_item.dart';
import 'package:planova_app/features/group/data/models/group_model.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';

class GroupTopInfo extends StatelessWidget {
  const GroupTopInfo({super.key, required this.groupEntity});
  final GroupEntity groupEntity;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.kStroke),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: groupEntity.accentColor,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              groupEntity.name[0],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupEntity.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.kDarkBlue,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.circle, size: 7, color: AppColors.kGreen),
                    SizedBox(width: 4),
                    Text(
                      groupEntity.status.badge,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.kColdGrey,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${groupEntity.memberUids.length} members',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.kColdGrey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  groupEntity.description,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.kColdGrey,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
