// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// class MockFirestore extends Mock implements FirebaseFirestore {}

// class MockCollectionReference extends Mock implements CollectionReference {}

// class MockDocumentReference extends Mock implements DocumentReference {}

// class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

// void main() {
//   MockFirestore firestore;
//   MockCollectionReference collectionReference;
//   MockDocumentReference documentReference;
//   MockDocumentSnapshot documentSnapshot;

//   setUp(() {
//     firestore = MockFirestore();
//     collectionReference = MockCollectionReference();
//     documentReference = MockDocumentReference();
//     documentSnapshot = MockDocumentSnapshot();
//   });

//   test('should get list of all the documents.', () async {
//     // arrange
//     when(firestore.collection(any)).thenReturn(collectionReference);
//     when(collectionReference.doc(any)).thenReturn(documentReference);
//     when(
//       documentReference.get(),
//     ).thenAnswer((_) async => documentSnapshot);
//     when(documentSnapshot.data()).thenReturn(roomsMap);
//     when(
//       documentReference.collection(any),
//     ).thenReturn(collectionReference);
//     when(
//       collectionReference.get(),
//     ).thenAnswer((_) async => mockQuerySnapshot);
//     when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
//     when(mockQueryDocumentSnapshot.data()).thenReturn(membersMap);
//     //act
//     final result = await remoteDataSource.fetchUsers();
//     //assert
//     expect(result, users);
//   });
// }
