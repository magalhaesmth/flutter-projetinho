import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Usuario extends StatelessWidget {
  Future<List<Map<String, Object?>>> buscarDados() async {
    String caminho = join(await getDatabasesPath(), "banco.db");
    deleteDatabase(caminho);
    Database banco = await openDatabase(
      caminho,
      version: 1,
      onCreate: (db, version) {
        db.execute('''CREATE TABLE usuario(
          id INTEGER PRIMARY KEY,
          nome TEXT NOT NULL,
          email TEXT NOT NULL)''');
        db.execute(
            'INSERT INTO usuario(nome, email) VALUES ("Nome", "Matheus Magalhães Urbano")');
        db.execute(
            'INSERT INTO usuario(nome, email) VALUES ("Email", "matheusinho@ifpr.com")');
      },
    );

    List<Map<String, Object?>> lista =
        await banco.rawQuery('SELECT * FROM usuario');
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Informações do Usuario"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, "/formTarefa");
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: buscarDados(),
        builder:
            (context, AsyncSnapshot<List<Map<String, Object?>>> dadosFuturos) {
          if (!dadosFuturos.hasData) {
            return const CircularProgressIndicator();
          }
          var listaUsuario = dadosFuturos.data!;

          return ListView.builder(
              itemCount: listaUsuario.length,
              itemBuilder: (context, contador) {
                var usuario = listaUsuario[contador];
                return ListTile(
                  title: Text(usuario['nome'].toString()),
                  subtitle: Text(usuario['email'].toString()),
                );
              });
        },
      ),
    );
  }
}
