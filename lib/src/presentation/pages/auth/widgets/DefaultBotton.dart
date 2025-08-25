import 'package:flutter/material.dart';

class Defaultbotton extends StatelessWidget {
  String text;
  Function() onPressed;
  Color color;

  Defaultbotton({
    required this.text,
    required this.onPressed,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(backgroundColor: color),
        child: Text(text, style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
