import 'package:get/get.dart';
import 'package:myapp/app/modules/detail_bubuk/bindings/detail_bubuk_binding.dart';
import 'package:myapp/app/modules/detail_bubuk/views/detail_bubuk_view.dart';
import 'package:myapp/app/modules/minuman_saji/bindings/produk_detail_binding.dart';
import 'package:myapp/app/modules/minuman_saji/views/produk_detail_view.dart';
import 'package:myapp/app/modules/stock/bindings/stock_binding.dart';
import 'package:myapp/app/modules/stock/views/coffe_powder_view.dart';
import 'package:myapp/app/modules/stock/views/stock_coffee.dart';

import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/landing_page/bindings/landing_page_binding.dart';
import '../modules/landing_page/views/landing_page_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LANDING_PAGE;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.LANDING_PAGE,
      page: () => LandingPageView(),
      binding: LandingPageBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.DETAILBUBUK,
      page: () => detail_bubuk_view(),
      binding: detailbubukbinding(),
    ),
    GetPage(
      name: _Paths.MINUMANSAJI,
      page: () => ProductDetailView(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: _Paths.STOCK,
      page: () => stockcoffeeview(),
      binding: stockbinding(),
    ),
  ];
}
