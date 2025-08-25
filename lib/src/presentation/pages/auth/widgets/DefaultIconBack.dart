import 'package:flutter/material.dart';

class Defaulticonback extends StatelessWidget {
  double izq;
  double top;

  Defaulticonback({required this.izq, required this.top});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: izq, top: top),
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back, size: 40, color: Colors.white),
      ),
    );
  }
}
