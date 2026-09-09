import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiClient {
  static const String baseUrl = 'http://localhost:3000';

  late final Dio dio;

  ApiClient() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
    dio.options.headers['Cache-Control'] = 'no-cache'; // ← here, if you want it

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final user = FirebaseAuth.instance.currentUser;
          final token = await user?.getIdToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }
}