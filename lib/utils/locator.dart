import 'package:get_it/get_it.dart';

import '../services/provider/auth_provider.dart';
import '../services/provider/auth_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<AuthProvider>(AuthProvider());
  locator.registerSingleton<AuthService>(AuthService());
}
