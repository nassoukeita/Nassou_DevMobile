import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MonPanier extends StatefulWidget {
  final List<Map<String, dynamic>> cart;

  MonPanier({required this.cart});


  @override
  _MonPanierState createState() => _MonPanierState();
}

class _MonPanierState extends State<MonPanier> {
  final Stream<QuerySnapshot> _panierStream = FirebaseFirestore.instance
      .collection("panier")
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection("items")
      .snapshots();
  //late Stream<QuerySnapshot> _panierStream;
  List<DocumentSnapshot> _panier = [];

  double _calculateTotal(QuerySnapshot snapshot) {
    double total = 0.0;
    snapshot.docs.forEach((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      double prix = data['prix']?.toDouble() ?? 0.0;
      total += prix;
    });
    return total;
  }

  @override
  void initState() {
    _loadPanier();
    //_panierStream = FirebaseFirestore.instance.collection('panier').snapshots();
  }

  //String _currentCategory = 'Tous les vêtements';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon panier'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _panierStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Une erreur est survenue : ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final panierDocs = snapshot.data!.docs;

          if (panierDocs.isEmpty) {
            return const Center(child: Text('Votre panier est vide.'));
          }

          double total = _calculateTotal(snapshot.data!);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: panierDocs.length,
                    itemBuilder: (context, index) {
                      final doc = panierDocs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              doc['image'].toString(),
                              height: 150,
                              width: 150,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doc['titre'].toString(),
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'marque: ',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${doc['marque']}',
                                  ),
                                  Text(
                                    'taille: ',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${doc['taille']}',
                                  ),
                                  Text(
                                    'prix: ',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${doc['prix']} €',
                                  ),

                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => _removeFromPanier(doc),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$total €',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final docs = await FirebaseFirestore.instance.collection('panier').get();
          final vetement = docs.docs.first;
          _addToPanier(vetement);
        },
        child: const Icon(Icons.add_shopping_cart),
      ),
    );
  }


  void _removeFromPanier(DocumentSnapshot doc) { // définit la méthode pour retirer un article du panier
    FirebaseFirestore.instance..collection("panier")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items")
        .doc(doc.id)
        .delete(); // supprime le document correspondant dans la collection "panier"
  }

  void _addToPanier(DocumentSnapshot doc) {
    setState(() {
      _panier.add(doc);
    });
  }

  void _loadPanier() async {
    final snapshot = await FirebaseFirestore.instance.collection('panier').get();
    setState(() {
      _panier = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).cast<DocumentSnapshot<Object?>>().toList();

    });
  }
}

