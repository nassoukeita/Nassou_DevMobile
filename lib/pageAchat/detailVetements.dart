import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miage/pageAchat/page-achat.dart';

class DetailVetement extends StatefulWidget {
  final String id;
  final dynamic data;

  const DetailVetement({required this.id, required this.data, Key? key})
      : super(key: key);

  @override
  _DetailVetementState createState() => _DetailVetementState();
}

class _DetailVetementState extends State<DetailVetement> {
  Future<void> _addToPanier(Map<String, dynamic> data) async {
    try {
      print('Data received: $data'); // <-- Ajout pour débogage
      final user = FirebaseAuth.instance.currentUser;
      final CollectionReference panierCollection = FirebaseFirestore.instance
          .collection('panier')
          .doc(user!.email)
          .collection('items');

      await panierCollection.add({
        'titre': data['titre'],
        'marque': data['marque'],
        'taille': data['taille'],
        'prix': data['prix'],
        'image': data['image'],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le vêtement a été ajouté au panier'),
        ),
      );
    } catch (e) {
      print('Erreur lors de l\'ajout au panier: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Une erreur est survenue, veuillez réessayer.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail du vêtement'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  height: 300,
                  width: 250,
                  child: Image.network(widget.data['image'], fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.data['titre'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Taille: ${widget.data['taille']}'),
                    const SizedBox(height: 8),
                    Text('Marque: ${widget.data['marque']}'),
                    const SizedBox(height: 8),
                    Text('Prix: ${widget.data['prix']} €',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _addToPanier(widget.data),
                      child: Text('Ajouter au panier'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListeVetements(),
                          ),
                        );
                      },
                      child: const Text('retour'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
