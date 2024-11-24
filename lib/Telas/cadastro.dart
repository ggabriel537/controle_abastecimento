import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class CadastroLogin extends StatefulWidget {
  @override
  State<CadastroLogin> createState() => _CadastroLoginState();
}

class _CadastroLoginState extends State<CadastroLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final FirebaseAuth autenticacao = FirebaseAuth.instance;

  void _cadastrarUsuario() async {
    final String email = emailController.text.trim();
    final String senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Preencha todos os campos.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await autenticacao.createUserWithEmailAndPassword(email: email, password: senha);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cadastro realizado com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
    emailController.clear();
    senhaController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Login'),
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
              onPressed: _cadastrarUsuario,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
