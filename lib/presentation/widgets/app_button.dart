import 'package:flutter/material.dart';
import 'package:kanban_assignment/core/constants/context_extensions.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool outlined;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: outlined
            ? context.theme.disabledColor
            : context.theme.colorScheme.primaryContainer,
        side: outlined
            ? BorderSide(color: context.theme.colorScheme.primary)
            : BorderSide.none,
        foregroundColor: context.theme.colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 48),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
