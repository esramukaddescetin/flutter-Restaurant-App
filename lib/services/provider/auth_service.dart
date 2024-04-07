import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../screens/quick_requests.dart';

class AuthService {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> signUp(BuildContext context,
      {required String name,
      required String lastname,
      required String email,
      required int phone,
      required String password}) async {
    final navigator = Navigator.of(context);

    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await _registerUser(
            name: name,
            lastname: lastname,
            email: email,
            phone: phone,
            password: password);
        navigator.push(
          MaterialPageRoute(
            builder: (context) => QuickRequestsPage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> signIn(
      BuildContext context, String email, String password) async {
    final navigator = Navigator.of(context);
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        //giriş başarılı

        navigator.push(
          MaterialPageRoute(
            builder: (context) => QuickRequestsPage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> _registerUser(
      {required String name,
      required String lastname,
      required String email,
      required int phone,
      required String password}) async {
    await userCollection.doc().set(
      {
        "name": name,
        "lastname": lastname,
        "email": email,
        "phone": phone,
        "password": password,
      },
    );
  }
}
