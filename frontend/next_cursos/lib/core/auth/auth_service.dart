import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/mock/auth_mock.dart';

class AuthService extends ChangeNotifier {
  static const String _boxName = 'authBox';
  static const String _userKey = 'currentUser';

  // Singleton
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  AuthCredentialMock? _currentUser;
  AuthCredentialMock? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;
  bool get isEstudante => _currentUser?.type == UserType.estudante;
  bool get isInstituicao => _currentUser?.type == UserType.instituicao;

  String get credencialId => _currentUser?.email ?? "";

  Future<void> init() async {
    final box = await Hive.openBox(_boxName);
    final savedData = box.get(_userKey);

    if (savedData != null && savedData is Map) {
      final String userId = savedData['userId'];
      final String typeName = savedData['type'];

      try {
        _currentUser = authCredentialsMock.firstWhere(
          (c) => c.userId == userId && c.type.name == typeName,
        );
      } catch (_) {
        await box.delete(_userKey);
      }
    }
  }

  Future<bool> login(String email, String password, UserType type) async {
    // Simula atraso de rede
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final credential = authCredentialsMock.firstWhere(
        (c) => c.email == email && c.password == password && c.type == type,
      );

      _currentUser = credential;

      final box = Hive.box(_boxName);
      await box.put(_userKey, {
        'userId': credential.userId,
        'type': credential.type.name,
      });

      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    final box = Hive.box(_boxName);
    await box.delete(_userKey);
    notifyListeners();
  }
}
