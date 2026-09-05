enum ModalidadeCurso {
  presencial,
  online,
  hibrido,
}

enum TipoOportunidade {
  cursoGratuito,
  bolsaParcial,
  bolsaIntegral,
}

enum StatusOportunidade {
  rascunho,
  publicada,
  inscricoesAbertas,
  inscricoesEncerradas,
  encerrada,
  cancelada,
}

enum StatusInscricao {
  pendente,
  inscrita,
  emAnalise,
  convocadoParaAvaliacao,
  emProcessoSeletivo,
  aprovado,
  listaEspera,
  reprovado,
  cancelada,
}

enum TipoAvaliacao {
  provaObjetiva,
  provaDissertativa,
  entrevista,
  analiseCurricular,
  analiseDocumental,
}

enum StatusResultado {
  aprovado,
  listaEspera,
  reprovado,
  desclassificado,
}