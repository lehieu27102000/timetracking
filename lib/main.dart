import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:trackingtime/services/auth.dart';
import 'app/landing_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Provider<AuthBase>(
        create: (context) => Auth(),
        child: MaterialApp(
          title: 'my app',
          theme: ThemeData (
              primaryColor: Colors.deepPurple
          ),
          home: LandingPage(),
        ),
    );
  }
}