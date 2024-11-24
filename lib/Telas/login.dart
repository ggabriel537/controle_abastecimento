import 'package:controleabastecimento/Telas/principal.dart';
import 'package:controleabastecimento/Telas/recuperarsenha.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:controleabastecimento/Telas/cadastro.dart';

class LoginUsuario extends StatefulWidget {
  @override
  State<LoginUsuario> createState() => _LoginUsuarioState();
}

class _LoginUsuarioState extends State<LoginUsuario> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  final FirebaseAuth _autenticacao = FirebaseAuth.instance;

  Future<void> _logar() async {
    final String email = emailController.text.trim();
    final String senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, preencha todos os campos.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await _autenticacao.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login realizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Principal()),
      );

    } on FirebaseAuthException catch (e) {
      String erro;
      if (e.code == 'user-not-found') {
        erro = 'Usuário não encontrado!';
      } else if (e.code == 'wrong-password') {
        erro = 'Senha incorreta!';
      } else {
        if (e.code == 'invalid-email') {
          erro = 'E-mail inválido!';
        } else {
          erro = 'Erro desconhecido!';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(erro),
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
        title: Text('Login'),
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
            TextField(
              decoration: InputDecoration(
                labelText: 'Senha',
              ),
              controller: senhaController,
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logar,
              child: Text('Entrar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroLogin(),
                  ),
                );
              },
              child: Text("Cadastro de Login"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Recuperarsenha(),
                  ),
                );
              },
              child: Text("Recuperar Senha"),
            )
          ],
        ),
      ),
    );
  }
}
