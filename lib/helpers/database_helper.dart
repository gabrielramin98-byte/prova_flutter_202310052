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
        // REQUISITO: Tabela com campo extra 'turnoAtendimento'
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
}
