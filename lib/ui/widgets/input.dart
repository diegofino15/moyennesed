import 'package:flutter/material.dart';
import 'package:moyennesed/ui/styles.dart';

class Input extends StatefulWidget {
  final String placeholder;
  final String? initialValue;
  final bool hideText;

  final Function changeValueFunction;
  final Function submitFunction;

  const Input({
    super.key,
    required this.placeholder,
    this.initialValue = "",
    required this.hideText,
    required this.changeValueFunction,
    required this.submitFunction,
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 60.0 * Styles.scale_,
      child: TextFormField(
        autocorrect: false,
        obscureText: widget.hideText,
        obscuringCharacter: "*",
        initialValue: widget.initialValue ?? "",
        onChanged: (String value) => widget.changeValueFunction(value),
        onFieldSubmitted: (String value) => widget.submitFunction(value),
        style:  Styles.itemTextStyle,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.placeholder,
          labelStyle: Styles.itemTextStyle
        ),
      ),
    );
  }
}
