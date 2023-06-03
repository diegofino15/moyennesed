import 'package:flutter/material.dart';
import 'package:moyennesed/ui/styles.dart';


class LoadingAnimation extends StatefulWidget {
  final double size;
  
  const LoadingAnimation({
    super.key,
    this.size = 25.0,
  });

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.size * Styles.scale,
          width: widget.size * Styles.scale,
          child: CircularProgressIndicator(
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            strokeWidth: 4.0 * Styles.scale,
          ),
        ),
      ],
    );
  }
}
