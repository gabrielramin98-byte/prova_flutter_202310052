import 'package:flutter/material.dart';
import 'helpers/database_helper.dart';
import 'models/tarefa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prova Flutter 202310052',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // REQUISITO: Cores personalizadas Teal e GreenAccent
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
        ).copyWith(secondary: Colors.greenAccent),
        useMaterial3:
            false, // Usando Material 2 para garantir cores exatas do tema
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper();
  List<Tarefa> tarefas = [];

  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descController = TextEditingController();
  final _prioridadeController = TextEditingController();
  final _turnoController = TextEditingController(); // Seu campo extra

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  void _atualizarLista() async {
    final data = await dbHelper.queryAllTarefas();
    setState(() {
      tarefas = data.map((item) => Tarefa.fromMap(item)).toList();
    });
  }

  void _mostrarFormulario({Tarefa? tarefa}) {
    if (tarefa != null) {
      _tituloController.text = tarefa.titulo;
      _descController.text = tarefa.descricao;
      _prioridadeController.text = tarefa.prioridade;
      _turnoController.text = tarefa.turnoAtendimento;
    } else {
      _tituloController.clear();
      _descController.clear();
      _prioridadeController.clear();
      _turnoController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 15,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextFormField(
                controller: _prioridadeController,
                decoration: const InputDecoration(
                  labelText: 'Prioridade (Baixa/Média/Alta)',
                ),
              ),
              // REQUISITO: Campo Extra na UI
              TextFormField(
                controller: _turnoController,
                decoration: const InputDecoration(
                  labelText: 'Turno de Atendimento',
                ),
                validator: (v) => v!.isEmpty ? 'Informe o turno' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final novaTarefa = Tarefa(
                      id: tarefa?.id,
                      titulo: _tituloController.text,
                      descricao: _descController.text,
                      prioridade: _prioridadeController.text,
                      criadoEm: DateTime.now().toString(),
                      turnoAtendimento: _turnoController.text,
                    );

                    if (tarefa == null) {
                      await dbHelper.insertTarefa(novaTarefa.toMap());
                    } else {
                      await dbHelper.updateTarefa(novaTarefa.toMap());
                    }
                    _tituloController.clear();
                    _descController.clear();
                    _prioridadeController.clear();
                    _turnoController.clear();
                    Navigator.of(context).pop();
                    _atualizarLista();
                  }
                },
                child: Text(tarefa == null ? 'Salvar' : 'Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deletarTarefa(int id) async {
    await dbHelper.deleteTarefa(id);
    _atualizarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tarefas Profissionais - 202310052')),
      body: ListView.builder(
        itemCount: tarefas.length,
        itemBuilder: (context, index) {
          final item = tarefas[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                item.titulo,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.descricao),
                  Text(
                    'Turno: ${item.turnoAtendimento}',
                    style: TextStyle(color: Colors.teal[800]),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () => _mostrarFormulario(tarefa: item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deletarTarefa(item.id!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent, // Cor Secundária
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () => _mostrarFormulario(),
      ),
    );
  }
}
