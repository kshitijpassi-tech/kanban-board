import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Extension methods on [BuildContext] for easier and cleaner access
/// to frequently used features in a scalable Flutter app.
extension ContextExtensions on BuildContext {
  // /// MediaQuery
  // Size get screenSize => MediaQuery.of(this).size;
  // double get screenWidth => MediaQuery.of(this).size.width;
  // double get screenHeight => MediaQuery.of(this).size.height;
  // double get viewPaddingTop => MediaQuery.of(this).viewPadding.top;
  // double get viewPaddingBottom => MediaQuery.of(this).viewPadding.bottom;
  // double get viewInsetsBottom => MediaQuery.of(this).viewInsets.bottom;
  // Orientation get orientation => MediaQuery.of(this).orientation;

  /// Theme & Colors
  ThemeData get theme => Theme.of(this);
  // TextTheme get textTheme => Theme.of(this).textTheme;
  // ColorScheme get colorScheme => Theme.of(this).colorScheme;
  // Color get primaryColor => Theme.of(this).primaryColor;
  // Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;

  // /// Navigator
  // void pop<T extends Object?>([T? result]) => Navigator.of(this).pop(result);
  // Future<T?> push<T>(Route<T> route) => Navigator.of(this).push(route);
  // Future<T?> pushNamed<T>(String routeName, {Object? arguments}) =>
  //     Navigator.of(this).pushNamed(routeName, arguments: arguments);
  // void pushReplacementNamed(String routeName, {Object? arguments}) =>
  //     Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
  // void popUntil(String routeName) =>
  //     Navigator.of(this).popUntil(ModalRoute.withName(routeName));

  /// SnackBar
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? color,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: color,
      ),
    );
  }

  /// Dialog
  // Future<T?> showDialogBox<T>({
  //   required WidgetBuilder builder,
  //   bool barrierDismissible = true,
  // }) {
  //   return showDialog<T>(
  //     context: this,
  //     builder: builder,
  //     barrierDismissible: barrierDismissible,
  //   );
  // }

  Future<T?> showAlertDialog<T>({
    required String title,
    required String content,
    String confirmText = 'OK',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return showDialog<T>(
      context: this,
      builder: (context) => AlertDialog.adaptive(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => context.pop(), child: Text(cancelText)),
          TextButton(
            onPressed: () => context.pop(true),
            style: isDestructive
                ? TextButton.styleFrom(foregroundColor: Colors.red)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Focus
  void unFocus() {
    FocusScopeNode currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.unfocus();
    }
  }

  /// Scaffold
  // ScaffoldState get scaffold => Scaffold.of(this);
  // ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);
}
