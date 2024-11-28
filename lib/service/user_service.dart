import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveBiodata({

    required String firstName,
    required String lastName,
    required String role,
    String? grade,
  }) async{
    final user = _auth.currentUser;

    if(user != null){
      final data = {
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
        'isBiodataComplete': true,
      };
      if(role == 'Student' && grade != null){
        data['grade'] = grade;
      }

      await _firestore.collection('Users').doc(user.uid).set(data, SetOptions(merge: true));
    }
  }
}