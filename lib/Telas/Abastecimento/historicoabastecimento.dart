import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'AdicionarAbastecimento.dart';
import 'package:intl/intl.dart';

class HistoricoAbastecimento extends StatelessWidget {
  Stream<List<Map<String, dynamic>>> _obterAbastecimentos() {
    final user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection('Abastecimentos')
        .where('email', isEqualTo: user!.email)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Abastecimentos'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _obterAbastecimentos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum abastecimento registrado.'));
          }
          final listaAbastecimentos = snapshot.data!;
          return ListView.builder(
            itemCount: listaAbastecimentos.length,
            itemBuilder: (context, index) {
              final abastecimento = listaAbastecimentos[index];
              final data = (abastecimento['data'] as Timestamp).toDate();
              final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(data);

              return ListTile(
                title: Text('Veículo: ${abastecimento['nome_veiculo']}'),
                subtitle: Text(
                  'Quantidade: ${abastecimento['quantidade']}L\n'
                      'Quilometragem: ${abastecimento['quilometragem']} km\n'
                      'Data: $formattedDate',
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdicionarAbastecimento(),
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Cadastrar Abastecimento',
      ),
    );
  }
}