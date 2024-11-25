import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controleabastecimento/Telas/Drawer/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Principal extends StatelessWidget {
  Stream<List<Map<String, dynamic>>> _obterVeiculos() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value([]);
    return FirebaseFirestore.instance
        .collection('Veiculos')
        .where('email', isEqualTo: user.email)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Veiculos'),
      ),
      drawer: DrawerWidget(),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _obterVeiculos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum veiculo foi cadastrado\nUtilize a função de cadastro'));
          }
          final listaVeic = snapshot.data!;
          return ListView.builder(
            itemCount: listaVeic.length,
            itemBuilder: (context, index) {
              final veiculo = listaVeic[index];
              return ListTile(
                title: Text(veiculo['nome']),
                subtitle: Text(
                    'Modelo: ${veiculo['modelo']}, '
                        'Placa: ${veiculo['placa']}'
                ),
              );
            },
          );
        },
      ),
    );
  }
}
