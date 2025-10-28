import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseHelper {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FirebaseHelper({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : auth = auth ?? FirebaseAuth.instance,
       firestore = firestore ?? FirebaseFirestore.instance;

  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  String? get currentUserId => auth.currentUser?.uid;
  User? get currentUser => auth.currentUser;
}
