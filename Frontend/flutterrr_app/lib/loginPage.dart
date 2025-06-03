import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterrr_app/dashboard.dart';
import 'package:flutterrr_app/signupPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'colors.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async{
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async{
    if(_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty){
      var reqBody = {
        "email":_emailController.text,
        "password":_passwordController.text
      };

      var response = await http.post(Uri.parse(login),
          headers: {"Content-Type":"application/json"},
          body: jsonEncode(reqBody)
      );
      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['status']);

      if (jsonResponse['status']){
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage(token: myToken)),
        );
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong'),
            duration: Duration(seconds: 3), // Stays visible for 3 seconds
            backgroundColor: Colors.red, // Optional: Red to indicate error
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.black54),
                    errorText: _isNotValidate && _emailController.text.isEmpty
                        ? 'Please enter your email'
                        : null,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.black54),
                    errorText: _isNotValidate && _passwordController.text.isEmpty
                        ? 'Please enter your password'
                        : null,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: ()=>{
                    loginUser()
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Login', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupPage()),
                    );
                  },
                  child: const Text(
                    'Don\'t have an account? Sign Up',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

