import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:miage/pageAchat/detailVetements.dart';
import 'package:miage/pageAchat/panier.dart';

import '../login/pageLogin.dart';

class ListeVetements extends StatefulWidget {
  const ListeVetements({Key? key}) : super(key: key);

  @override
  _ListeVetementsState createState() => _ListeVetementsState();
}

class _ListeVetementsState extends State<ListeVetements>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Stream<QuerySnapshot> _vetementsStream =
      FirebaseFirestore.instance.collection('vetements').snapshots();

  String _selectedCategory = 'Tous';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Liste des vêtements'),
          bottom: TabBar(
            controller: _tabController,
            onTap: (index) {
              setState(() {
                switch (index) {
                  case 0:
                    _selectedCategory = 'Tous';
                    break;
                  case 1:
                    _selectedCategory = 'jupe';
                    break;
                  case 2:
                    _selectedCategory = 'robe';
                    break;
                  case 3:
                    _selectedCategory = 'veste';
                    break;
                }
              });
            },
            tabs: [
              Tab(text: 'Tous'),
              Tab(text: 'Jupe'),
              Tab(text: 'Robe'),
              Tab(text: 'Veste'),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _vetementsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading');
            }

            Query query = FirebaseFirestore.instance.collection('vetements');
            if (_selectedCategory != 'Tous') {
              query = query.where('categorie', isEqualTo: _selectedCategory);
            }

            return ListView(
              children: snapshot.data!.docs
                  .where((document) =>
              _selectedCategory == 'Tous' ||
                  document['categorie'] == _selectedCategory)
                  .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailVetement(
                          id: '',
                          data: data,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: Image.network(data['image']),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['titre'],
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(data['taille']),
                                  Text(
                                    '${double.parse(data['prix'].toString())} €',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailVetement(
                                    id: '',
                                    data: data,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
