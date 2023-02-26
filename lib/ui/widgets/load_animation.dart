import 'package:flutter/material.dart';

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
      children: const [
        SizedBox(
          height: 20.0,
          width: 20.0,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            strokeWidth: 4.0,
          ),
        ),
      ],
    );
  }
}
