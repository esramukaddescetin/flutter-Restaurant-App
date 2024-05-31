import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/entry_table_no.dart';

class AuthService {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebaseAnonymous = FirebaseAuth.instance;

  Future<void> signUp(BuildContext context,
      {required String name,
      required String lastname,
      required String email,
      required String phone,
      required String password}) async {
    final navigator = Navigator.of(context);

    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCollection.doc(userCredential.user!.uid).set({
        'email': email,
        'name': name,
        'lastname': lastname,
        'phone': phone,
        'password': password,
        'role': 'user', // Kullanıcıya varsayılan olarak 'user' rolü atanır
      });

      // Kullanıcı başarılı bir şekilde kaydedildikten sonra, kullanıcı paneline yönlendirme yapılır
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TableNumberPage()),
      );
    } catch (e) {
      // Kayıt işlemi başarısız olursa, hata mesajını gösterin
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to register: $e'),
      ));
    }
  }

  Future<void> signIn(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      dynamic role = snapshot.get('roles');

      if (role is List<dynamic> && role.contains('User')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TableNumberPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You are not authorized to access this app.'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to sign in: $e'),
      ));
    }
  }

  Future<void> _registerUser(
      {required String name,
      required String lastname,
      required String email,
      required String role,
      required String phone,
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

  Future signInAnonymous() async {
    try {
      final result = await firebaseAnonymous.signInAnonymously();
      print(result.user!.uid);
      return result.user;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
