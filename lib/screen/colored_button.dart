import 'package:flutter/material.dart';

class ColoredButton extends StatelessWidget {
  const ColoredButton(
      {super.key, required this.child, required this.onPressed, this.iconData});
  final Widget child;
  final Function onPressed;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.amber),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 50,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconData != null) Icon(iconData),
            if (iconData != null)
              SizedBox(
                width: 10,
              ),
            child,
            SizedBox(
              width: 20,
            )
          ],
        ),
      ),
    );
  }
}
