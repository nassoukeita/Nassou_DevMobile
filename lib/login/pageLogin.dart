import 'package:flutter/material.dart';
import 'package:miage/login/service.dart';
import '../pageAchat/bottomNavigation.dart';

class PageLogin extends StatefulWidget {
  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final _auth = Service();
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _error = '';

  void _onEmailChanged(String value) {
    setState(() {
      _email = value;
    });
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _password = value;
    });
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final result = await _auth.signInWithEmailAndPassword(_email, _password);

      if (result == null) {
        setState(() {
          _error = 'Vos identifiants sont incorrects';
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigation()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NassouFashion'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.pink,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Login',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrer votre mail';
                    }
                    return null;
                  },
                  onChanged: _onEmailChanged,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Mot de passe',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Entrer un mot de passe de +6 caractères';
                    }
                    return null;
                  },
                  onChanged: _onPasswordChanged,
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pink,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: _onSubmit,
                  child: Text(
                    'Se connecter',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  _error,
                  style: TextStyle(
                    color: Colors.red,
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
