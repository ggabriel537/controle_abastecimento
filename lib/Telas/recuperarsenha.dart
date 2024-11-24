import 'package:controleabastecimento/Telas/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Recuperarsenha extends StatefulWidget {
  @override
  State<Recuperarsenha> createState() => _RecuperarsenhaState();
}

class _RecuperarsenhaState extends State<Recuperarsenha> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _autenticacao = FirebaseAuth.instance;

  void _recuperarSenha() async {
    final String email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('E-mail em branco!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await _autenticacao.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('E-mail de recuperação enviado!'),
          backgroundColor: Colors.green,
        ),
      );
      emailController.clear();
    } on FirebaseAuthException catch (e) {
      String erro;
      if (e.code == 'user-not-found') {
        erro = "E-mail não encontrado!";
      } else {
        erro = "Erro desconhecido!";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erro),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperação de Senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'E-mail',
              ),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _recuperarSenha,
              child: Text('Enviar e-mail de recuperação'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginUsuario()),
                );
              },
              child: Text('Voltar para o Login'),
            ),
          ],
        ),
      ),
    );
  }
}
