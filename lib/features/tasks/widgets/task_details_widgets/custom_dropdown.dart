import 'package:flutter/material.dart';

class DropdownItemModel {
  final String value;
  final IconData icon;
  final Color color;
  DropdownItemModel({required this.value, required this.icon, required this.color,});
}

class CustomDropdown extends StatelessWidget {
  final String label;
  final List<DropdownItemModel> items;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final Widget? icon;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) icon!,
            if (icon != null) const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item.value,
              child: Row(
                children: [
                  Icon(item.icon, size: 20,   color: item.color,),
                  const SizedBox(width: 8),
                  Text(item.value),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
