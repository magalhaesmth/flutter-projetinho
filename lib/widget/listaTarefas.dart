import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ListaTarefas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/formTarefa');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _buscarDados(),
        builder: (context,
            AsyncSnapshot<List<Map<String, Object?>>> dadosRetornados) {
          if (!dadosRetornados.hasData) {
            return const CircularProgressIndicator();
          }
          var listaTarefas = dadosRetornados.data!;

          return ListView.builder(
            itemCount: listaTarefas.length,
            itemBuilder: (context, index) {
              var tarefa = listaTarefas[index];

          return Card(
            elevation: 4,
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.pinkAccent,
                    child: Text(listaTarefas[index]["nome"]
                        .toString()
                        .substring(0, 1)
                        .toUpperCase()),
                  ),
                  title: Text(tarefa['nome'].toString()),
                  subtitle: Text(tarefa['descricao'].toString()),
                  trailing: const Icon(Icons.arrow_forward_ios_outlined),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, Object?>>> _buscarDados() async {
    String path = join(await getDatabasesPath(), 'task_list');
    deleteDatabase(path);
    Database dataBase = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        db.execute('''
          CREATE TABLE tarefa (
          id INT PRIMARY KEY,
          nome TEXT NOT NULL,
          descricao TEXT NOT NULL)
        ''');
        db.execute(
            'INSERT INTO tarefa (nome, descricao) VALUES ("Prova da Luciana", "14/07")');
        db.execute(
            'INSERT INTO tarefa (nome, descricao) VALUES ("Recibo em React", "14/07")');
        db.execute(
            'INSERT INTO tarefa (nome, descricao) VALUES ("Prova CRUD PW", "15/07")');
        db.execute(
            'INSERT INTO tarefa (nome, descricao) VALUES ("Aula de SO", "13/07")');
      },
    );
    List<Map<String, Object?>> retorno =
        await dataBase.rawQuery('SELECT * FROM tarefa');
    return retorno;
  }
}

