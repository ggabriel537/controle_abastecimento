import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdicionarAbastecimento extends StatefulWidget {
  @override
  State<AdicionarAbastecimento> createState() => _AdicionarAbastecimentoState();
}

class _AdicionarAbastecimentoState extends State<AdicionarAbastecimento> {
  final _quantidadeController = TextEditingController();
  final _quilometragemController = TextEditingController();
  String _veiculoSelecionado = '';
  DateTime? _dataAbastecimento;
  TimeOfDay? _horaAbastecimento;

  Future<List<Map<String, dynamic>>> _obterVeiculos() async {
    final user = FirebaseAuth.instance.currentUser;
    final snapshot = await FirebaseFirestore.instance
        .collection('Veiculos')
        .where('email', isEqualTo: user!.email)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> _salvarAbastecimento() async {
    if (_quantidadeController.text.isEmpty ||
        _quilometragemController.text.isEmpty ||
        _veiculoSelecionado.isEmpty ||
        _dataAbastecimento == null ||
        _horaAbastecimento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Todos os campos são obrigatórios!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final dataHoraAbastecimento = DateTime(
      _dataAbastecimento!.year,
      _dataAbastecimento!.month,
      _dataAbastecimento!.day,
      _horaAbastecimento!.hour,
      _horaAbastecimento!.minute,
    );

    try {
      await FirebaseFirestore.instance.collection('Abastecimentos').add({
        'email': FirebaseAuth.instance.currentUser!.email,
        'veiculo': _veiculoSelecionado,
        'nome_veiculo': _veiculoSelecionado,
        'quantidade': double.parse(_quantidadeController.text),
        'quilometragem': int.parse(_quilometragemController.text),
        'data': dataHoraAbastecimento,
      });

      _quantidadeController.clear();
      _quilometragemController.clear();
      setState(() {
        _veiculoSelecionado = '';
        _dataAbastecimento = null;
        _horaAbastecimento = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Abastecimento registrado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao registrar abastecimento: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selecionarVeiculo() async {
    final veiculos = await _obterVeiculos();
    final veiculoSelecionado = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Selecione o Veículo'),
          content: SingleChildScrollView(
            child: Column(
              children: veiculos.map((veiculo) {
                return ListTile(
                  title: Text(veiculo['nome']),
                  onTap: () {
                    Navigator.pop(context, veiculo['nome']);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (veiculoSelecionado != null) {
      setState(() {
        _veiculoSelecionado = veiculoSelecionado;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veiculo selecionado: $veiculoSelecionado'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }


  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataAbastecimento ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (data != null) {
      setState(() {
        _dataAbastecimento = data;
      });
    }
  }

  Future<void> _selecionarHora() async {
    final TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: _horaAbastecimento ?? TimeOfDay.now(),
    );
    if (hora != null) {
      setState(() {
        _horaAbastecimento = hora;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Abastecimento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _selecionarVeiculo,
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Selecionar Veiculo',
                  hintText: 'Selecione um veículo'
                ),
              ),
            ),
            TextField(
              controller: _quantidadeController,
              decoration: InputDecoration(
                labelText: 'Quantidade (litros)',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _quilometragemController,
              decoration: InputDecoration(
                labelText: 'Quilometragem Atual',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(_dataAbastecimento == null
                    ? 'Selecione a Data'
                    : 'Data: ${_dataAbastecimento!.toLocal()}'),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _selecionarData,
                ),
              ],
            ),
            Row(
              children: [
                Text(_horaAbastecimento == null
                    ? 'Selecione a Hora'
                    : 'Hora: ${_horaAbastecimento!.hour}:${_horaAbastecimento!.minute}'),
                IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: _selecionarHora,
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarAbastecimento,
              child: Text('Registrar Abastecimento'),
            ),
          ],
        ),
      ),
    );
  }
}
