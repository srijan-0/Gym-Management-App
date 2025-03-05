// class ApiEndpoints {
//   ApiEndpoints._();

//   static const Duration connectionTimeout = Duration(seconds: 1000);
//   static const Duration receiveTimeout = Duration(seconds: 1000);
//   static const String baseUrl = "http://10.0.2.2:8000/api/";
//   // static const String baseUrl = "http://127.0.0.1:8000/api/";

//   // static const String baseUrl = "http://192.168.101.14:5000/api/";

//   // For iPhone
//   //static const String baseUrl = "http://localhost:3000/api/v1/";

//   // ====================== Auth Routes ======================
//   static const String login = "signin";
//   static const String register = "signup";

//   static const String imageUrl = "http://10.0.2.2:3000/uploads/";
//   // static const String imageUrl = "http://192.168.101.14:5000/uploads/";
//   static const String uploadImage = "auth/uploadImage";
// }

//for real device

class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  // static const String baseUrl = "http://10.0.2.2:8000/api/";   //for emulator
  // static const String baseUrl = "http://127.0.0.1:8000/api/";   //for pos

  static const String baseUrl =
      "http://192.168.101.13:8000/api/"; //for real device

  // static const String baseUrl = "http://192.168.101.14:5000/api/";

  // For iPhone
  //static const String baseUrl = "http://localhost:3000/api/v1/";

  // ====================== Auth Routes ======================
  static const String login = "signin";
  static const String register = "signup";

  // static const String imageUrl = "http://10.0.2.2:3000/uploads/";
  // static const String imageUrl = "http://127.0.0.1:8000/uploads/";
  static const String imageUrl = "http://192.168.101.13:8000/uploads/";
  static const String uploadImage = "auth/uploadImage";
}
