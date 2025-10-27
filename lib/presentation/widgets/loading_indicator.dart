import 'package:flutter/material.dart';
import 'package:kanban_assignment/core/constants/context_extensions.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator.adaptive(
        backgroundColor: context.theme.colorScheme.primary,
      ),
    );
  }
}
