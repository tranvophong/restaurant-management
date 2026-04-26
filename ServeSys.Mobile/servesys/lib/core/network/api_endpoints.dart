class ApiEndpoints {
  static const baseUrl = 'https://localhost:7228';
  static const areas = '/api/Area';

  static const tables = '/api/Table';
  static String tablesByArea(int areaId) => '$tables/$areaId';

  static const menuCategories = '/api/Menu/categories';
  static String menuItemsByCategory(int categoryId) => '/api/Menu/$categoryId';

  static const placeOrder = '/api/Order/place';
}