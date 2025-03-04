import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../app/constants/hive_table_constant.dart';
import '../../features/auth/data/model/auth_hive_model.dart';

class HiveService {
  static Future<void> init() async {
    // Initialize the database
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}softwarica_customer_management.db';

    Hive.init(path);

    Hive.registerAdapter(AuthHiveModelAdapter());
  }

  // Auth Queries
  Future<void> register(AuthHiveModel auth) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.customerBox);
    await box.put(auth.userId, auth);
  }

  Future<void> deleteAuth(String id) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.customerBox);
    await box.delete(id);
  }

  Future<List<AuthHiveModel>> getAllAuth() async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.customerBox);
    return box.values.toList();
  }

  // Login using username and password
  Future<AuthHiveModel?> login(String username, String password) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.customerBox);
    var customer = box.values.firstWhere(
        (element) => element.email == username && element.password == password);
    box.close();
    return customer;
  }

  Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.customerBox);
  }

  // Clear customer Box
  Future<void> clearcustomerBox() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.customerBox);
  }

  Future<void> close() async {
    await Hive.close();
  }
}

// import 'package:hive/hive.dart';

// class HiveService {
//   // Assuming you have a Hive box for customer data (user profile, token, etc.)
//   // If not already open, ensure to open it before using (perhaps in your app init).
//   static const String _customerBoxName = 'customerBox';
//   late Box _customerBox;

//   HiveService() {
//     // Open the Hive box (synchronously or use async init if needed)
//     _customerBox = Hive.box(_customerBoxName);
//   }

//   /// Save auth token to Hive storage
//   Future<void> saveToken(String token) async {
//     await _customerBox.put('token', token);
//   }

//   /// Retrieve the saved auth token (or null if not present)
//   String? getToken() {
//     return _customerBox.get('token');
//   }

//   /// Remove the auth token from storage
//   Future<void> clearToken() async {
//     await _customerBox.delete('token');
//   }

//   /// Clear all customer data from the Hive box (e.g. on full logout)
//   Future<void> clearCustomerBox() async {
//     await _customerBox.clear();
//   }
// }
