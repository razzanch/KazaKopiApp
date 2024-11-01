import 'package:get/get.dart';

import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/coffe_powder/bindings/coffe_powder_binding.dart';
import '../modules/coffe_powder/views/coffe_powder_view.dart';
import '../modules/deleteacc/bindings/deleteacc_binding.dart';
import '../modules/deleteacc/views/deleteacc_view.dart';
import '../modules/detail_bubuk/bindings/detail_bubuk_binding.dart';
import '../modules/detail_bubuk/views/detail_bubuk_view.dart';
import '../modules/detail_minuman/bindings/detail_minuman_binding.dart';
import '../modules/detail_minuman/views/detail_minuman_view.dart';
import '../modules/helpcenter/bindings/helpcenter_binding.dart';
import '../modules/helpcenter/views/helpcenter_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/landing_page/bindings/landing_page_binding.dart';
import '../modules/landing_page/views/landing_page_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/mainprofile/bindings/mainprofile_binding.dart';
import '../modules/mainprofile/views/mainprofile_view.dart';
import '../modules/myfav/bindings/myfav_binding.dart';
import '../modules/myfav/views/myfav_view.dart';
import '../modules/myorder/bindings/myorder_binding.dart';
import '../modules/myorder/views/myorder_view.dart';
import '../modules/order/bindings/order_binding.dart';
import '../modules/order/views/order_view.dart';
import '../modules/ourig/bindings/ourig_binding.dart';
import '../modules/ourig/views/ourig_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/resetpw/bindings/resetpw_binding.dart';
import '../modules/resetpw/views/resetpw_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/stock/bindings/stock_binding.dart';
import '../modules/stock/views/stock_view.dart';

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
      name: _Paths.DETAIL_BUBUK,
      page: () => DetailBubukView(),
      binding: DetailBubukBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_MINUMAN,
      page: () => DetailMinumanView(),
      binding: DetailMinumanBinding(),
    ),
    GetPage(
      name: _Paths.STOCK,
      page: () => StockView(),
      binding: StockBinding(),
    ),
    GetPage(
      name: _Paths.COFFE_POWDER,
      page: () => CoffePowderView(),
      binding: CoffePowderBinding(),
    ),
    GetPage(
      name: _Paths.ORDER,
      page: () => OrderView(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: _Paths.MAINPROFILE,
      page: () => MainProfileView(),
      binding: MainProfileBinding(),
    ),
    GetPage(
      name: _Paths.HELPCENTER,
      page: () => HelpcenterView(),
      binding: HelpcenterBinding(),
    ),
    GetPage(
      name: _Paths.MYFAV,
      page: () => MyfavView(),
      binding: MyfavBinding(),
    ),
    GetPage(
      name: _Paths.MYORDER,
      page: () => MyorderView(),
      binding: MyorderBinding(),
    ),
    GetPage(
      name: _Paths.OURIG,
      page: () => OurigView(),
      binding: OurigBinding(),
    ),
    GetPage(
      name: _Paths.RESETPW,
      page: () => ResetpwView(),
      binding: ResetpwBinding(),
    ),
    GetPage(
      name: _Paths.DELETEACC,
      page: () => DeleteaccView(),
      binding: DeleteaccBinding(),
    ),
  ];
}
