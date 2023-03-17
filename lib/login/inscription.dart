
import 'service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:miage/login/pageLogin.dart';



class PageIncription extends StatefulWidget {
  const PageIncription({Key? key}) : super(key: key);

  @override
  _PageIncriptionState createState() => _PageIncriptionState();
}

class _PageIncriptionState extends State<PageIncription> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _adresseController = TextEditingController();
  final _codePostalController = TextEditingController();
  final _villeController = TextEditingController();
  final _anniversaireController = TextEditingController();



  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        await FirebaseFirestore.instance
            .collection('user')
            .doc(userCredential.user!.uid)
            .set({
          'email': _emailController.text,
          'adresse': _adresseController.text,
          'codePostal': _codePostalController.text,
          'ville': _villeController.text,
          'anniversaire': _anniversaireController.text,
        });

        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          _showErrorDialog('Le mot de passe est trop faible.');
        } else if (e.code == 'email-already-in-use') {
          _showErrorDialog('Un compte avec cet e-mail existe déjà.');
        } else {
          _showErrorDialog(
              'Erreur lors de l\'inscription. Veuillez réessayer.');
        }
      } catch (e) {
        _showErrorDialog('Erreur lors de l\'inscription. Veuillez réessayer.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.person,
                size: 80,
                color: Colors.black,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Adresse e-mail',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer une adresse e-mail.';
                  }
                  if (!value.contains('@')) {
                    return 'Veuillez entrer une adresse e-mail valide.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: _obscurePassword
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Veuillez entrer votre mot de passe';
                  } else if (val.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: _obscureConfirmPassword
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Veuillez confirmer votre mot de passe';
                  } else if (val != _passwordController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _signupPressed,
                child: const Text('S\'inscrire'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PageLogin(),
                    ),
                  );
                },
                child: const Text('Déjà inscrit ? Connectez-vous ici'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signupPressed() async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      final String adresse = _adresseController.text.trim();
      final String codePostal = _codePostalController.text.trim();
      final String ville = _villeController.text.trim();
      final DateTime dateNaissance = _anniversaireController.text.isNotEmpty ? DateTime.parse(_anniversaireController.text) : DateTime.now();
      try {
        await Service().signUpWithEmailAndPassword(
          email,
          password,
          adresse,
          codePostal,
          ville,
          dateNaissance,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PageLogin(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Une erreur s\'est produite';
        if (e.code == 'email-already-in-use') {
          errorMessage = 'Cet email est déjà utilisé';
        }
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Erreur'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
