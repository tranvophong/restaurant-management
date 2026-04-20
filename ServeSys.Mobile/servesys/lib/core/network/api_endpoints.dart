class ApiEndpoints {
  static const baseUrl = 'https://localhost:7228';
  static const areas = '/api/Area';

  static const tables = '/api/Table';
  static String tablesByArea(int areaId) => '$tables/$areaId';
}