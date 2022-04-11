import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:the_validator/the_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:users_app/authentication/signup_screen.dart';
import 'package:users_app/splashScreen/splash_screen.dart';

import '../global/global.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  // ignore: unnecessary_new
  final GlobalKey _textKey = new GlobalKey();
  // ignore: unnecessary_new
  final GlobalKey _textsKey = new GlobalKey();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  LoginUserNow() async {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
          Container(
              margin: const EdgeInsets.only(left: 5),
              child: const Text("Signing In, Please wait...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    final User? firebaseUser = (await fAuth
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + msg.toString());
    }))
        .user;

    if (firebaseUser != null) {
      DatabaseReference driversRef =
          FirebaseDatabase.instance.ref().child("users");
      driversRef.child(firebaseUser.uid).once().then((driverKey) {
        final snap = driverKey.snapshot;
        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Login Successful");
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()));
        } else {
          Fluttertoast.showToast(msg: "No record exists with this email");
          fAuth.signOut();
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()));
        }
      });
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occured, Unable to Sign In.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    // ));
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(90.0),
                  child: Image.asset(
                    isDarkMode
                        ? "images/helpy_user_darkmode.png"
                        : "images/helpy_user.png",
                  ),
                ),
                const SizedBox(
                  height: 0,
                ),
                const Text(
                  "Login as a User",
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  // height: 50,
                  width: 320,
                  child: TextFormField(
                    controller: emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.grey, fontSize: 17),
                    decoration: InputDecoration(
                      labelText: "Email",
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                      ),

                      //for the errors
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    validator: (value) => EmailValidator.validate(value!)
                        ? null
                        : "Please enter a valid email",
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  // height: 50,
                  width: 320,
                  child: TextFormField(
                    controller: passwordTextEditingController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    style: const TextStyle(color: Colors.grey, fontSize: 17),
                    decoration: InputDecoration(
                      labelText: "Password",
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                      ),

                      //for handling error layout
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 320,
                  child: Align(
                    alignment: const Alignment(1, 0),
                    child: RichText(
                        key: _textsKey,
                        text: TextSpan(
                            text: 'Forgot Password?',
                            style: const TextStyle(
                                color: Colors.lightBlueAccent, fontSize: 14),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.of(context).push(
                                  PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          SignUpScreen(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        // const begin = Offset(0.0, 1.0);
                                        // const end = Offset.zero;
                                        // const curve = Curves.ease;

                                        // var tween = Tween(begin: begin, end: end)
                                        //     .chain(CurveTween(curve: curve));

                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );

                                        // return SlideTransition(
                                        //   position: animation.drive(tween),
                                        //   child: child,
                                        // );
                                      })))),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 320,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        LoginUserNow();
                        return;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlueAccent),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                RichText(
                    key: _textKey,
                    text: TextSpan(children: <TextSpan>[
                      const TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                          text: 'Register Here',
                          style: const TextStyle(
                              color: Colors.lightBlueAccent, fontSize: 14),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.of(context).push(
                                PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        SignUpScreen(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      // const begin = Offset(0.0, 1.0);
                                      // const end = Offset.zero;
                                      // const curve = Curves.ease;

                                      // var tween = Tween(begin: begin, end: end)
                                      //     .chain(CurveTween(curve: curve));

                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );

                                      // return SlideTransition(
                                      //   position: animation.drive(tween),
                                      //   child: child,
                                      // );
                                    }))),
                    ])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
