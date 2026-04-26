abstract class ApiClient {
  Future<dynamic> get(String path);
  Future<dynamic> post(String path, {Object? data});
}