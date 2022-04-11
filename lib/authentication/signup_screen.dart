// ignore_for_file: unnecessary_new

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:form_field_validator/form_field_validator.dart';
import 'package:the_validator/the_validator.dart';
import 'package:users_app/authentication/login_screen.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/splashScreen/splash_screen.dart';

// ignore: use_key_in_widget_constructors
class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmpasswordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey _textKey = new GlobalKey();

  saveUseInfoNow() async {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
          Container(
              margin: const EdgeInsets.all(18),
              child: const Text("Processing, Please wait...")),
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
            .createUserWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + msg.toString());
    }))
        .user;

    if (firebaseUser != null)
    {
      Map userMap = {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      DatabaseReference reference =
          FirebaseDatabase.instance.ref().child("users");
      reference.child(firebaseUser.uid).set(userMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account has been created");
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => MySplashScreen()));
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been created");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    // ));
    return Scaffold(
      // backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
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
                  "Register as a User",
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
                    controller: nameTextEditingController,
                    style: const TextStyle(color: Colors.grey, fontSize: 17),
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0),
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
                    validator: (value) {
                      if (value!.isNotEmpty && value.length >= 3) {
                        return null;
                      } else if (value.length < 3 && value.isNotEmpty) {
                        return 'Enter a Name with three characters or more';
                      } else {
                        return 'This field is required';
                      }
                    },
                  ),
                  // validator:
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
                    controller: phoneTextEditingController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.grey, fontSize: 17),
                    decoration: InputDecoration(
                      labelText: "Phone",
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
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
                    validator: FieldValidator.password(
                        minLength: 8,
                        shouldContainNumber: true,
                        shouldContainCapitalLetter: true,
                        shouldContainSmallLetter: true,
                        shouldContainSpecialChars: true,
                        errorMessage: "Password must match the required format",
                        onNumberNotPresent: () {
                          return "Password must contain at least one Number";
                        },
                        onSpecialCharsNotPresent: () {
                          return "Password must contain special characters";
                        },
                        onCapitalLetterNotPresent: () {
                          return "Must contain CAPITAL letters";
                        }),
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
                      //
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  width: 320,
                  child: Text(
                    "\u2022 Password must be at least 8 characters",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  width: 320,
                  child: Text(
                    "\u2022 Password must contain at least one Capital letter",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 320,
                  child: Align(
                    alignment: Alignment(-0.9, 0),
                    child: Text(
                      "Number, and Special Character",
                      // textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  // height: 50,
                  width: 320,
                  child: TextFormField(
                    controller: confirmpasswordTextEditingController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    style: const TextStyle(color: Colors.grey, fontSize: 17),
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
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

                      //for the error message
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
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return 'Empty';
                    //   }
                    //   if (value != confirmpasswordTextEditingController.text) {
                    //     return 'Not Match';
                    //   }
                    //   return null;
                    // },
                    validator: FieldValidator.equalTo(
                        passwordTextEditingController,
                        message: "Password mismatch"),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 320,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        // showLoaderDialog(context);
                        saveUseInfoNow();
                        return;
                      }

                      // Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlueAccent),
                    child: const Text(
                      "Create Account",
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
                        text: "Already have an account? ",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                          text: 'Login Here',
                          style: const TextStyle(
                              color: Colors.lightBlueAccent, fontSize: 14),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.of(context).push(
                                PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const LoginScreen(),
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
