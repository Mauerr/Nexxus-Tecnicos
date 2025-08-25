import 'package:flutter/material.dart';

class DefaultTextfield extends StatelessWidget {

  String? errorText;
  String label;
  IconData icon;
  Function(String text) onChange;
  bool obscureText;

  DefaultTextfield({
    required this.label,
    required this.icon,
    required this.onChange,
    this.errorText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      onChanged: (Text) {
        onChange(Text);
      },
      decoration: InputDecoration(
        label: Text(label, style: TextStyle(color: Colors.white)),
        errorText: errorText,
        prefixIcon: Icon(icon, color: Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}
