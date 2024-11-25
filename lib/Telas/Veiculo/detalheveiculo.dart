import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetalheVeiculo extends StatefulWidget {
  final String id;
  final String nome;
  final String modelo;
  final String placa;

  DetalheVeiculo({required this.id, required this.nome, required this.modelo, required this.placa});

  @override
  State<DetalheVeiculo> createState() => _DetalheVeiculoState();
}

class _DetalheVeiculoState extends State<DetalheVeiculo> {
  final _nomeController = TextEditingController();
  final _modeloController = TextEditingController();
  final _placaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.nome;
    _modeloController.text = widget.modelo;
    _placaController.text = widget.placa;
  }

  Future<void> _atualizarVeiculo() async {
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
      await FirebaseFirestore.instance.collection('Veiculos').doc(widget.id).update({
        'nome': nome,
        'modelo': modelo,
        'placa': placa,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veículo atualizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar veículo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _removerVeiculo() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja remover este veículo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmar ?? false) {
      try {
        await FirebaseFirestore.instance.collection('Veiculos').doc(widget.id).delete();
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao remover veículo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Veículo'),
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
              onPressed: _atualizarVeiculo,
              child: Text('Atualizar Veículo'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _removerVeiculo,
              child: Text('Remover Veículo'),
            ),
          ],
        ),
      ),
    );
  }
}
