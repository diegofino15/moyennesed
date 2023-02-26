import 'package:flutter/material.dart';
import 'package:moyennesed/ui/styles.dart';

class BoxWidget extends StatelessWidget {
  final Widget child;

  const BoxWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: Styles.mainWidgetBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: child,
    );
  }
}
