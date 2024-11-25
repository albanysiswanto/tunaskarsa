import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tunaskarsa/pages/dashboard_page.dart';
import 'package:tunaskarsa/pages/login_page.dart';

class AuthService {

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
    required BuildContext context
  }) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
        );
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (BuildContext context) => DashboardPage())
        );
    } on FirebaseAuthMultiFactorException catch(e){
      String message = '';
      if(e.code == 'user-not-found'){
        message = 'Email atau user tidak ditemukan.';
      }else if(e.code == 'wrong-password'){
        message = 'Anda memasukan password yang salah.';
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

}