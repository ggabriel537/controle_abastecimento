import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AlterarSenha extends StatefulWidget {
  @override
  _AlterarSenhaState createState() => _AlterarSenhaState();
}

class _AlterarSenhaState extends State<AlterarSenha> {
  final _senhaAtualController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarNovaSenhaController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String _mensagemErro = '';

  Future<void> _alterarSenha() async {
    final senhaAtual = _senhaAtualController.text;
    final novaSenha = _novaSenhaController.text;
    final confirmarNovaSenha = _confirmarNovaSenhaController.text;

    if (senhaAtual.isEmpty || novaSenha.isEmpty || confirmarNovaSenha.isEmpty) {
      setState(() {
        _mensagemErro = 'Todos os campos são obrigatórios!';
      });
      return;
    }

    if (novaSenha != confirmarNovaSenha) {
      setState(() {
        _mensagemErro = 'As novas senhas não coincidem!';
      });
      return;
    }

    try {
      User? user = _auth.currentUser;
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: senhaAtual,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(novaSenha);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Senha alterada!'),
          backgroundColor: Colors.green),
      );
      _senhaAtualController.clear();
      _novaSenhaController.clear();
      _confirmarNovaSenhaController.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        setState(() {
          _mensagemErro = 'A senha atual está incorreta.';
        });
      } else {
        setState(() {
          _mensagemErro = 'Erro desconhecido: ${e.message}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alterar Senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _senhaAtualController,
              decoration: InputDecoration(
                labelText: 'Senha Atual',
              ),
              obscureText: true,
            ),
            TextField(
              controller: _novaSenhaController,
              decoration: InputDecoration(
                labelText: 'Nova Senha',
              ),
              obscureText: true,
            ),
            TextField(
              controller: _confirmarNovaSenhaController,
              decoration: InputDecoration(
                labelText: 'Confirmar Nova Senha',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _alterarSenha,
              child: Text('Alterar Senha'),
            ),
            if (_mensagemErro.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _mensagemErro,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
