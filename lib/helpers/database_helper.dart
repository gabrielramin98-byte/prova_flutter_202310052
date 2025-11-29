import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tarefas_202310052.db');
    print('LOCATION_DB: O arquivo do banco está em: $path');
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    // REQUISITO: Nome do banco com o RA
    final path = join(dbPath, 'tarefas_202310052.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE tarefas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            descricao TEXT,
            prioridade TEXT,
            criadoEm TEXT,
            turnoAtendimento TEXT
          )
        ''');
      },
    );
  }

  // Create
  Future<int> insertTarefa(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('tarefas', row);
  }

  // Read
  Future<List<Map<String, dynamic>>> queryAllTarefas() async {
    Database db = await database;
    return await db.query('tarefas');
  }

  // Update
  Future<int> updateTarefa(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['id'];
    return await db.update('tarefas', row, where: 'id = ?', whereArgs: [id]);
  }

  // Delete
  Future<int> deleteTarefa(int id) async {
    Database db = await database;
    return await db.delete('tarefas', where: 'id = ?', whereArgs: [id]);
  }
}
