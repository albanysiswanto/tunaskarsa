import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tunaskarsa/firebase_options.dart';
import 'package:tunaskarsa/pages/biodataUser_page.dart';
import 'package:tunaskarsa/pages/dashboard_page.dart';
import 'package:tunaskarsa/service/auth_service.dart';
import 'pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final user = FirebaseAuth.instance.currentUser;
  Widget initialPage;

  if(user != null){
    final isComplete = await AuthService().checkUserData();
    if(isComplete){
      initialPage = DashboardPage();
    }else{
      initialPage = BiodataPage();
    }
  }else{
    initialPage = LoginPage();
  }

  runApp(MyApp(initialPage: initialPage));
}

class MyApp extends StatelessWidget {
  final Widget initialPage;
  const MyApp({super.key, required  this.initialPage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: initialPage,
    );
  }
}