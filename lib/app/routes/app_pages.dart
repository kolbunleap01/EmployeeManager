import 'package:get/get.dart';

import '../../modules/auth/views/login_view.dart';
import '../../modules/employees/controllers/employee_controller.dart';
import '../../modules/employees/views/employee_form_view.dart';
import '../../modules/employees/views/employee_list_view.dart';
import '../../modules/home/controllers/home_controller.dart';
import '../../modules/home/views/home_view.dart';
import '../../modules/products/controllers/product_controller.dart';
import '../../modules/products/views/product_list_view.dart';
import 'auth_middleware.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(name: AppRoutes.login, page: () => const LoginView()),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: BindingsBuilder(() => Get.lazyPut(HomeController.new)),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.products,
      page: () => const ProductListView(),
      binding: BindingsBuilder(() => Get.lazyPut(ProductController.new)),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.employees,
      page: () => const EmployeeListView(),
      binding: BindingsBuilder(() => Get.lazyPut(EmployeeController.new)),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.addEmployee,
      page: () => const EmployeeFormView(),
      binding: BindingsBuilder(() => Get.lazyPut(EmployeeController.new)),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.editEmployee,
      page: () => const EmployeeFormView(),
      binding: BindingsBuilder(() => Get.lazyPut(EmployeeController.new)),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
