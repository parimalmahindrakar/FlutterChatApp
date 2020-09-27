import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat20/model/user.dart';
class AuthMethods {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyUser _userFromFirebaseUser(User user) {
    return user != null ? MyUser(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
    }
  }

  Future resetPassword(String email)  async {
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e);
    }
  }
  Future signOut()  async {
    try{
      return await _auth.signOut();
    }catch(e){
      print(e);
    }
  }
}