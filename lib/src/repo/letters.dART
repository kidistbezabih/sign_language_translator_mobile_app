import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _letterCollection = _firestore.collection('letters');

class LettersRepo {
  static Stream<QuerySnapshot> getLetterByName(String name) {
    CollectionReference letter = _letterCollection.doc
  }
}