import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TarefaForm extends StatelessWidget {
  String? nome;
  String? descricao;

  Future<int> salvar(String nome, String descricao, [int? id]) async {
    String caminho = join(await getDatabasesPath(), 'banco.db');
    Database banco = await openDatabase(caminho, version: 1);

    String sql;
    Future<int> linhasAfetadas;
    if (id == null) {
      sql = 'INSERT INTO tarefa (nome, descricao) VALUES (?, ?)';
      linhasAfetadas = banco.rawInsert(sql, [nome, descricao]);
    } else {
      sql = 'UPDATE tarefa SET nome = ?, descricao = ? WHERE id = ?';
      linhasAfetadas = banco.rawDelete(sql, [nome, descricao, id]);
    }
    return linhasAfetadas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cadastro de Tarefas"),
        ),
        body: Column(
          children: [
            TextField(
              decoration: InputDecoration(label: Text("Nome da Tarefa:")),
              onChanged: (value) => {},
            ),
            TextField(
              decoration: InputDecoration(label: Text("Descrição:")),
              onChanged: (value) => {},
            ),
            TextField(
              decoration: InputDecoration(label: Text("Data:")),
              onChanged: (value) => {},
            ),
          ],
        ));
  }
}
