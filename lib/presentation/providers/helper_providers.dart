import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/helpers/firebase_helper.dart';
import '../../core/helpers/network_helper.dart';

final firebaseHelperProvider = Provider<FirebaseHelper>((ref) {
  return FirebaseHelper();
});

final networkHelperProvider = Provider<NetworkHelper>((ref) {
  return NetworkHelper();
});
