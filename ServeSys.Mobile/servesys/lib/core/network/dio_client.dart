import 'package:dio/dio.dart';
import 'package:servesys/core/network/api_client.dart';
import 'package:servesys/core/network/api_endpoints.dart';

// dio configuration
class DioClient extends ApiClient{
  static final DioClient _instance = DioClient._interval();
  factory DioClient() => _instance;

  late final Dio dio;
  DioClient._interval() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
  }
  
  @override
  Future get(String path) async {
    final response = await dio.get(path);
    return response.data;
  }
}
