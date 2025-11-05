// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../../core/constants/network_helper.dart';
// import 'no_internet_screen.dart';

// class InternetWrapper extends ConsumerWidget {
//   final Widget child;

//   const InternetWrapper({super.key, required this.child});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return StreamBuilder<bool>(
//       stream: NetworkHelper.internetStatusStream,
//       builder: (context, snapshot) {
//         // Show loading while checking connection
//         if (!snapshot.hasData) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         // Show no internet screen if no connection
//         if (snapshot.data == false) {
//           return const NoInternetScreen();
//         }

//         // Show child if connected
//         return child;
//       },
//     );
//   }
// }
