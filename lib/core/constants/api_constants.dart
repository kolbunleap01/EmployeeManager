abstract final class ApiConstants {
  static const baseUrl = 'https://dummyjson.com';
  static const login = '/auth/login';
  static const products = '/products';
  static const users = '/users';
  static const addUser = '/users/add';
  static String user(int id) => '/users/$id';
}
