import 'package:flutter/material.dart';

class CustomDropdownMenu<T> extends StatelessWidget {
  List<DropdownMenuEntry<T>> items;
  String label;
  String hintText;
  T? initialValue;
  ValueChanged<T?> onChanged;
  CustomDropdownMenu(
      {required this.items,
      this.initialValue,
      required this.label,
      required this.hintText,
      required this.onChanged,
      super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
        width: MediaQuery.of(context).size.width * 0.5,
        onSelected: (value) {
          onChanged(value);
        },
        initialSelection: initialValue,
        label: Text(label),
        hintText: hintText,
        dropdownMenuEntries: items);
  }
}
