import 'package:artfolio/main_screen.dart';
import 'package:artfolio/registration.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'feed_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  void signInUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // User signed in successfully
        Fluttertoast.showToast(msg: 'Login successful');

        // Navigate to the Home Screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
        // Handle errors here, such as wrong password or no user found
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/login.jpg'),
                  fit: BoxFit.cover)),
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 135.0),
                  child: Text(
                    'ART\nFOLIO.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 70,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: const Color.fromARGB(255, 123, 123, 123)
                              .withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 7))
                    ],
                  ),
                  child: TextFormField(
                    onChanged: (value) => email = value,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'EMAIL',
                        fillColor: Colors.white,
                        hintStyle: const TextStyle(color: Color(0xFFDDDDDD)),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 27, horizontal: 15),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 7))
                    ],
                  ),
                  child: TextFormField(
                    onChanged: (value) => password = value,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'PASSWORD',
                        fillColor: Colors.white,
                        hintStyle: const TextStyle(color: Color(0xFFDDDDDD)),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 27, horizontal: 15),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 110, vertical: 30)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    onPressed: signInUser,
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 150.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationScreen()));
                      },
                      child: const Text(
                        "REGISTER",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
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
