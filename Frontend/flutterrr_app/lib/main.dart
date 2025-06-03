// import 'package:flutter/material.dart';
// import 'package:flutterrr_app/dashboard.dart';
// import 'package:flutterrr_app/signupPage.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'loginPage.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   runApp(MyApp(token: prefs.getString('token'),));
// }
//
// class MyApp extends StatelessWidget {
//   // const MyApp({super.key});
//
//   final token;
//   const MyApp({
//     @required this.token,
//     Key? key,
// }): super(key: key);
//
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//       ),
//       home: (JwtDecoder.isExpired(token) == false)? DashboardPage(token: token):const LoginPage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
//
import 'package:flutter/material.dart';
import 'package:flutterrr_app/dashboard.dart';
import 'package:flutterrr_app/signupPage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Get token, default to empty string if null
  String token = prefs.getString('token') ?? '';
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final token; // Non-nullable String

  const MyApp({
    required this.token, // Require a non-null value
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if token is empty or expired, navigate accordingly
    bool isTokenValid = token.isNotEmpty && !JwtDecoder.isExpired(token);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Added default theme
        useMaterial3: true,
      ),
      home: isTokenValid ? DashboardPage(token: token) : const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}