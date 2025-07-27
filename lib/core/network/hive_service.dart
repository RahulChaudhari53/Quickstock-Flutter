import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickstock/app/constant/hive_table_constant.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/auth/data/model/user_hive_model.dart';

class HiveService {
  Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}quickstock.db';

    Hive.init(path);

    Hive.registerAdapter(UserHiveModelAdapter());
  }

  // ============================================= User Queries =============================================
  // Future<void> registerUser(UserHiveModel user) async {
  //   var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);

  //   try {
  //     bool isDuplicate = box.values.any((existingUser) {
  //       final sameEmail =
  //           existingUser.email.trim().toLowerCase() ==
  //           user.email.trim().toLowerCase();
  //       final phoneOverlap = existingUser.phoneNumbers.any(
  //         (phone) => user.phoneNumbers.any(
  //           (newPhone) => newPhone.trim() == phone.trim(),
  //         ),
  //       );
  //       return sameEmail || phoneOverlap;
  //     });

  //     if (isDuplicate) {
  //       await box.close();
  //       throw LocalDatabaseFailure(
  //         message: "User with same email or phone number already exists.",
  //       );
  //     }

  //     await box.put(user.userId, user);
  //   } catch (e) {
  //     rethrow;
  //   } finally {
  //     await box.close();
  //   }
  // }

  Future<void> registerUser(UserHiveModel user) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);

    try {
      bool isDuplicate = box.values.any((existingUser) {
        final sameEmail =
            existingUser.email.trim().toLowerCase() ==
            user.email.trim().toLowerCase();

        final phoneOverlap =
            (existingUser.primaryPhone.trim() == user.primaryPhone.trim()) ||
            (existingUser.secondaryPhone?.trim() == user.primaryPhone.trim()) ||
            (user.secondaryPhone != null &&
                (existingUser.primaryPhone.trim() ==
                        user.secondaryPhone!.trim() ||
                    existingUser.secondaryPhone?.trim() ==
                        user.secondaryPhone!.trim()));

        return sameEmail || phoneOverlap;
      });

      if (isDuplicate) {
        await box.close();
        throw LocalDatabaseFailure(
          message: "User with same email or phone number already exists.",
        );
      }

      await box.put(user.userId, user);
    } catch (e) {
      rethrow;
    } finally {
      await box.close();
    }
  }

  // Future<UserHiveModel?> loginUser(String phoneNumber, String password) async {
  //   var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);

  //   var student = box.values.firstWhere(
  //     (element) =>
  //         element.phoneNumbers.contains(phoneNumber) &&
  //         element.password == password,
  //     orElse: () => throw LocalDatabaseFailure(message: "Invalid credentials."),
  //   );

  //   // await box.clear();
  //   await box.close();
  //   return student;
  // }

  Future<UserHiveModel?> loginUser(String phoneNumber, String password) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);

    try {
      var user = box.values.firstWhere(
        (user) =>
            (user.primaryPhone.trim() == phoneNumber.trim() ||
                user.secondaryPhone?.trim() == phoneNumber.trim()) &&
            user.password == password,
        orElse:
            () => throw LocalDatabaseFailure(message: "Invalid credentials."),
      );

      return user;
    } finally {
      await box.close();
    }
  }
}
