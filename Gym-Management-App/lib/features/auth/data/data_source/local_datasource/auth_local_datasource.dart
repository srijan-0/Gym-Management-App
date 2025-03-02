import 'dart:io';

import '../../../../../core/network/hive_service.dart';
import '../../../domain/entity/auth_entity.dart';
import '../../model/auth_hive_model.dart';
import '../auth_data_source.dart';

class AuthLocalDataSource implements IAuthDataSource {
  final HiveService _hiveService;

  AuthLocalDataSource(this._hiveService);

  @override
  Future<AuthEntity> getCurrentUser() {
    // Return Empty AuthEntity
    return Future.value(AuthEntity(
      userId: "1",
      name: "",
      userImage: "",
      email: "",
      password: "",
      cPassword: "", // Make sure cPassword is included here
    ));
  }

  @override
  Future<String> logincustomer(String email, String password) async {
    try {
      await _hiveService.login(email, password); // Adjusted to email
      return Future.value("Success");
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> registercustomer(AuthEntity customer) async {
    try {
      // Make sure the AuthEntity has the correct values
      final authHiveModel =
          AuthHiveModel.fromEntity(customer, customer.cPassword);

      await _hiveService.register(authHiveModel);
      return Future.value();
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) {
    throw UnimplementedError();
  }
}
