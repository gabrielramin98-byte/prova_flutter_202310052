class Tarefa {
  int? id;
  String titulo;
  String descricao;
  String prioridade;
  String criadoEm;
  String turnoAtendimento;

  Tarefa({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.prioridade,
    required this.criadoEm,
    required this.turnoAtendimento,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'prioridade': prioridade,
      'criadoEm': criadoEm,
      'turnoAtendimento': turnoAtendimento,
    };
  }

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      prioridade: map['prioridade'],
      criadoEm: map['criadoEm'],
      turnoAtendimento: map['turnoAtendimento'],
    );
  }
}
