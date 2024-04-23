import 'package:flutter/material.dart';

class CustomDropdownMenu<T> extends StatelessWidget {
  List<DropdownMenuItem<T>> items;
  String label;
  String hintText;
  T? value;
  ValueChanged<T?> onChanged;
  CustomDropdownMenu(
      {required this.items,
      this.value,
      required this.label,
      required this.hintText,
      required this.onChanged,
      super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
        dropdownColor: Colors.grey.shade200,
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        onChanged: (value) {
          onChanged(value);
        },
        value: value,
        hint: Text(hintText),
        items: items);
  }
}
