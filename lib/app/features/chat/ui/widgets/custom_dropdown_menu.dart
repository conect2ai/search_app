import 'package:flutter/material.dart';

class CustomDropdownMenu<T> extends StatelessWidget {
  List<DropdownMenuEntry<T>> items;
  String label;
  T? initialValue;
  ValueChanged<T?> onChanged;
  CustomDropdownMenu(
      {required this.items,
      this.initialValue,
      required this.label,
      required this.onChanged,
      super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
        onSelected: (value) {
          onChanged(value);
        },
        initialSelection: initialValue,
        label: Text(label),
        dropdownMenuEntries: items);
  }
}
