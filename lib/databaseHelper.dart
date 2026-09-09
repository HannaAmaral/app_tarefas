import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Databasehelper {
  static Database? _db;
//devolve o banco de dados ja aberto ou abre se ainda nao existe
  static Future<Database> get database async{
    _db ??= await abrirBanco();

    return _db!;
  }
//abre ou cria se nao existir o arquivo do banco de dados
  static Future<Database> abrirBanco() async{
    final caminho = join(await getDatabasesPath(),'tarefas.db');

    return openDatabase( caminho,
                  version: 1,
                  onCreate: (db, versao)
                  {
                    return db.execute('''CREATE TABLE tarefas 
                    (id INTEGER PRIMARY KEY AUTOINCREMENT,
                     titulo TEXT,
                      situacao INTEGER)''',);                 
                  }  
                );
  }
  static Future<List<Map<String, dynamic>>> buscarTarefa() async{
    final db = await Databasehelper.database;

    return db.query('tarefas'); //select * from tarefas
  }

  static Future<void> inserirTarefa(String titulo, ) async{
    final db = await Databasehelper.database;
    await db.insert('tarefas', {
      'titulo' : titulo,
      'situacao' : 0,
    });
     }
//UPDATE
     static Future<void> atualizarSituacao (int id, bool situacao) async {
      final db = await Databasehelper.database;
      await db.update('tarefas',
                      {'situacao': situacao},
                    where: 'id = ?',
                    whereArgs: [id],
          );
     }

     //delete

     static Future<void> removerSituacao (int id) async {
      final db = await Databasehelper.database;
      await db.delete( 'tarefas',
                    where: 'id = ?',
                    whereArgs: [id],
          );
     }

}