import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'login/pageLogin.dart';

class ProfilUtilisateur extends StatefulWidget {
  final User? user;

  ProfilUtilisateur({required this.user});

  @override
  _ProfilUtilisateurState createState() => _ProfilUtilisateurState();
}

class _ProfilUtilisateurState extends State<ProfilUtilisateur> {
  //final TextEditingController _anniversaireController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _codePostalController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();
DateTime? _selectedDate;

  late String _login;
  late String _password;

  @override
  void initState() {
    super.initState();
    _login = widget.user!.email!;
    _password = '••••••••';
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(widget.user!.uid).get();
    if (doc.exists) {
      final data = doc.data()!;
     // _anniversaireController.text = data['anniversaire'] ?? '';
      _adresseController.text = data['adresse'] ?? '';
      _codePostalController.text = data['code_postal'] ?? '';
      _villeController.text = data['ville'] ?? '';
      _selectedDate = (data['anniversaire'] as Timestamp?)?.toDate();
    }
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil utilisateur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Login: $_login'),
            const SizedBox(height: 16),
            const Divider(height: 20, thickness: 3),
            const SizedBox(height: 16),
            Text('Password: $_password'),
            const Divider(height: 20, thickness: 3),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Anniversaire',
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate != null
                          ? '${_selectedDate!.day}/${_selectedDate!
                          .month}/${_selectedDate!.year}'
                          : 'Sélectionner une date',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _adresseController,
              decoration: const InputDecoration(labelText: 'Adresse'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _codePostalController,
              decoration: const InputDecoration(labelText: 'Code postal'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _villeController,
              decoration: const InputDecoration(labelText: 'Ville'),
            ),
            const SizedBox(height: 18),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _updateUserData,
                    child: const Text('Valider'),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: (){
    Navigator.push(context, MaterialPageRoute(builder: (context) => PageLogin()));
    },
    child: Text('Se déconnecter'),

                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future<void> _updateUserData() async {
    await FirebaseFirestore.instance.collection('users').doc(widget.user!.uid).set({
      'anniversaire': _selectedDate,
      'adresse': _adresseController.text,
      'code_postal': _codePostalController.text,
      'ville': _villeController.text,
    }, SetOptions(merge: true));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Les modifications ont été enregistrées.')));
  }


}

