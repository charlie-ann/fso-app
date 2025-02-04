import 'package:flutter/material.dart';

class AppSwitch extends StatelessWidget {
  final bool enabled;
  final void Function(bool)? onChanged;
  final AlignmentGeometry? alignment;
  const AppSwitch(
      {super.key,
      required this.enabled,
      required this.onChanged,
      this.alignment = Alignment.center});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      alignment: alignment,
      scale: 0.5,
      child: Switch(
        value: enabled,
        onChanged: onChanged,
      ),
    );
  }
}
