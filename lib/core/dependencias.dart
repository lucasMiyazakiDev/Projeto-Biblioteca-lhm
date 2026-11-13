import 'package:get_it/get_it.dart';

import '../controller/cadastrar_usuario_controller.dart';
import '../controller/livro_controller.dart';
import '../controller/login_controller.dart';
import '../controller/perfil_controller.dart';
import '../controller/recuperar_senha_controller.dart';
import '../controller/sobre_controller.dart';
import '../model/sessao.dart';

final getIt = GetIt.instance;

/// Chame DEPOIS de Firebase.initializeApp() (veja o main.dart).
void configurarDependencias() {
  // um só objeto para o app inteiro (criado só no primeiro uso)
  getIt.registerLazySingleton<Sessao>(() => Sessao());
  getIt.registerLazySingleton<LivroController>(
      () => LivroController(getIt<Sessao>()));
  getIt.registerLazySingleton<SobreController>(() => SobreController());

  // um objeto novo a cada tela
  getIt.registerFactory<LoginController>(
      () => LoginController(getIt<Sessao>()));
  getIt.registerFactory<CadastrarUsuarioController>(
      () => CadastrarUsuarioController(getIt<Sessao>()));
  getIt.registerFactory<RecuperarSenhaController>(
      () => RecuperarSenhaController(getIt<Sessao>()));
  getIt.registerFactory<PerfilController>(
      () => PerfilController(getIt<Sessao>()));
}
