import 'package:controleabastecimento/Telas/login.dart';
import 'package:controleabastecimento/Telas/principal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deslogado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginUsuario(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao deslogar!\n${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menu de funções',
                  style: TextStyle(
                    color: Colors.white30,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Principal(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text('Meus Veículos'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Adicionar Veículo'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Histórico de Abastecimentos'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Perfil'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }
}
