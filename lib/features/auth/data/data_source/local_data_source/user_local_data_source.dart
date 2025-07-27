import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/core/network/hive_service.dart';
import 'package:quickstock/features/auth/data/data_source/user_data_source.dart';
import 'package:quickstock/features/auth/data/model/user_hive_model.dart';
import 'package:quickstock/features/auth/domain/entity/user_entity.dart';

class UserLocalDataSource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;
  @override
  Future<String> loginUser(String phoneNumber, String password) async {
    try {
      final userData = await _hiveService.loginUser(phoneNumber, password);
      if (userData != null && userData.password == password) {
        return "Login Successful";
      } else {
        throw LocalDatabaseFailure(
          message: 'Invalid phone number or password.',
        );
      }
    } catch (e) {
      throw LocalDatabaseFailure(message: 'Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      final userHiveModel = UserHiveModel.fromEntity(user);
      await _hiveService.registerUser(userHiveModel);
    } catch (err) {
      throw LocalDatabaseFailure(
        message: 'Registration failed: ${err.toString()}',
      );
    }
  }
}
