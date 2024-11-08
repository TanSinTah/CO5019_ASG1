import 'dart:ffi';

import 'package:el_realproject/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:el_realproject/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user=result.user;
      await DatabaseService(uid: user!.uid).setUserData(UserDetails(address: "N/A",phoneNumber: "N/A",icNumber: "N/A",username:  "N/A", imageUrl: ""));
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  //send reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
       await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

}