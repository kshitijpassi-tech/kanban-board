import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kanban_assignment/core/constants/context_extensions.dart';

import '../../../core/constants/network_helper.dart';

class ConnectivityListener extends ConsumerStatefulWidget {
  final Widget child;
  const ConnectivityListener({required this.child, super.key});

  @override
  ConsumerState<ConnectivityListener> createState() =>
      _ConnectivityListenerState();
}

class _ConnectivityListenerState extends ConsumerState<ConnectivityListener> {
  bool _isOffline = false;
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?
  _snackBarController;

  @override
  void initState() {
    super.initState();
    NetworkHelper.internetStatusStream.listen((hasInternet) {
      if (!hasInternet && !_isOffline) {
        _isOffline = true;

        // Remove previous snackbar if any
        _snackBarController?.close();

        _snackBarController = ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No internet connection'),
            backgroundColor: context.theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(days: 365), // persistent
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () async {
                final connected = await NetworkHelper.hasInternet();
                if (connected) {
                  _snackBarController?.close();
                }
              },
            ),
          ),
        );
      } else if (hasInternet && _isOffline) {
        _isOffline = false;

        // Close offline snackbar first
        _snackBarController?.close();

        // Show back online snackbar briefly
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Back online'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
