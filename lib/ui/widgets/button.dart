import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final double height;
  final Color color;
  final Function onPressed;
  final Widget child;

  const Button({
    super.key,
    required this.height,
    required this.color,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: height,
      child: MaterialButton(
        onPressed: () { onPressed(); },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        color: color,
        child: child,
      ),
    );
  }
}
