import '../../features/cursos/models/curso.dart';
import '../../shared/models/enums.dart';

final List<Curso> cursosMock = [
  const Curso(
    id: 'curso-001',
    instituicaoId: 'inst-001',
    nome: 'Engenharia de Software',
    descricao: 'Formação completa voltada para o desenvolvimento de sistemas complexos e gestão de projetos de software.',
    areaConhecimento: 'Tecnologia da Informação',
    modalidade: ModalidadeCurso.hibrido,
    cargaHoraria: 3200,
    duracaoMeses: 60,
    imagemUrl: '4.jpeg',
  ),
  const Curso(
    id: 'curso-002',
    instituicaoId: 'inst-002',
    nome: 'Desenvolvimento Web Fullstack',
    descricao: 'Aprenda a criar aplicações modernas utilizando as tecnologias mais requisitadas do mercado.',
    areaConhecimento: 'Tecnologia da Informação',
    modalidade: ModalidadeCurso.online,
    cargaHoraria: 800,
    duracaoMeses: 12,
    imagemUrl: '1.jpeg',
  ),
  const Curso(
    id: 'curso-003',
    instituicaoId: 'inst-003',
    nome: 'Administração de Empresas',
    descricao: 'Curso focado em gestão estratégica, finanças e liderança corporativa.',
    areaConhecimento: 'Gestão e Negócios',
    modalidade: ModalidadeCurso.online,
    cargaHoraria: 2800,
    duracaoMeses: 48,
    imagemUrl: '2.jpeg',
  ),
  const Curso(
    id: 'curso-004',
    instituicaoId: 'inst-001',
    nome: 'Análise de Dados e BI',
    descricao: 'Domine ferramentas e técnicas para transformar dados em inteligência de negócio.',
    areaConhecimento: 'Tecnologia da Informação',
    modalidade: ModalidadeCurso.online,
    cargaHoraria: 600,
    duracaoMeses: 10,
    imagemUrl: '3.jpeg',
  ),
];
