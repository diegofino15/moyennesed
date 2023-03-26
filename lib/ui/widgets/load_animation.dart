import 'package:flutter/material.dart';
import 'package:moyennesed/ui/styles.dart';

class LoadingAnim extends StatefulWidget {
  const LoadingAnim({super.key});

  @override
  State<LoadingAnim> createState() => _LoadingAnimState();
}

class _LoadingAnimState extends State<LoadingAnim> with SingleTickerProviderStateMixin {
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
          height: 20.0 * Styles.scale_,
          width: 20.0 * Styles.scale_,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            strokeWidth: 4.0 * Styles.scale_,
          ),
        ),
      ],
    );
  }
}
