import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdicionarVeiculo extends StatefulWidget {
  @override
  State<AdicionarVeiculo> createState() => _AdicionarVeiculoState();
}

class _AdicionarVeiculoState extends State<AdicionarVeiculo> {
  final _nomeController = TextEditingController();
  final _modeloController = TextEditingController();
  final _placaController = TextEditingController();

  Future<void> _adicionarVeiculo() async {
    final user = FirebaseAuth.instance.currentUser;

    final nome = _nomeController.text.trim();
    final modelo = _modeloController.text.trim();
    final placa = _placaController.text.trim();

    if (nome.isEmpty || modelo.isEmpty || placa.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Todos os campos são obrigatórios!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('Veiculos').add({
        'email': user!.email,
        'nome': nome,
        'modelo': modelo,
        'placa': placa,
      });

      _nomeController.clear();
      _modeloController.clear();
      _placaController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veículo adicionado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao adicionar veículo: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Veículo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome do Veículo',
              ),
            ),
            TextField(
              controller: _modeloController,
              decoration: InputDecoration(
                labelText: 'Modelo do Veículo',
              ),
            ),
            TextField(
              controller: _placaController,
              decoration: InputDecoration(
                labelText: 'Placa do Veículo',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _adicionarVeiculo,
              child: Text('Adicionar Veículo'),
            ),
          ],
        ),
      ),
    );
  }
}
