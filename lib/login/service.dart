import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Service {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Connexion avec email et mot de passe
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print(e.toString());
    }
  }

  // Inscription avec email et mot de passe
  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password, String adresse, String codePostal, String ville, DateTime dateNaissance) async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid).set({
        "adresse": adresse,
        "code_postal": codePostal,
        "ville": ville,
        "anniversaire": dateNaissance
      });
      return userCredential;
    } catch (e) {
      print(e.toString());
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }
}