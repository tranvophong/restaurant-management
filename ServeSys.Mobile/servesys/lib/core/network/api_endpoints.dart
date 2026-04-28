class ApiEndpoints {
  static const baseUrl = 'https://localhost:7228';

  // Auth
  static const login = '/api/auth/login';
  static const logout = '/api/auth/logout';
  static const refreshToken = '/api/auth/refresh-token';

  // Area & Table
  static const areas = '/api/Area';
  static const tables = '/api/Table';
  static String tablesByArea(int areaId) => '$tables/$areaId';

  // Menu
  static const menuCategories = '/api/Menu/categories';
  static String menuItemsByCategory(int categoryId) => '/api/Menu/$categoryId';

  // Order
  static const placeOrder = '/api/Order/place';
}