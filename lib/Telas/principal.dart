import 'package:controleabastecimento/Telas/login.dart';
import 'package:flutter/material.dart';
import 'Cadastro.dart';

class Principal extends StatelessWidget {

  void logout(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginUsuario()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Principal'),
      ),
      body: Column(
        children: [
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
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => logout(context),
                child: Text("Deslogar"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
