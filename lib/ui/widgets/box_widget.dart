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
      padding: EdgeInsets.all(20.0 * Styles.scale_),
      decoration: BoxDecoration(
        color: Styles.mainWidgetBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(20.0 * Styles.scale_)),
      ),
      child: child,
    );
  }
}
