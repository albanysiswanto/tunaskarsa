import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tunaskarsa/pages/biodataUser_page.dart';
import 'package:tunaskarsa/pages/dashboard_page.dart';
import 'package:tunaskarsa/pages/login_page.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context
  }) async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
        );
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (BuildContext context) => LoginPage())
        );
    } on FirebaseAuthMultiFactorException catch(e){
      String message = '';
      if(e.code == 'weak-password'){
        message = 'Kata sandi yang diberikan terlalu lemah.';
      }else if(e.code == 'email-already-in-use'){
        message = 'Email sudah digunakan atau terdaftar.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0
        );
    }
     catch(e){

    }
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await Future.delayed(const Duration(seconds: 1));

      final isComplete = await AuthService().checkUserData();
      if (isComplete) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BiodataPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'Email atau user tidak ditemukan.';
      } else if (e.code == 'wrong-password') {
        message = 'Anda memasukan password yang salah.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> signout({
    required BuildContext context
  })async{
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => LoginPage())
      );
  }

  Future<bool> checkUserData() async{
    final user = _auth.currentUser;

    if(user != null){
      final userDoc = await _firestore.collection('Users').doc(user.uid).get();
      if(userDoc.exists){
        return userDoc['isBiodataComplete'] ?? false;
      }
    }
    return false; // data null atau user belum login
  }

}