import 'package:get/get.dart';

import '../modules/adminanalytics/bindings/adminanalytics_binding.dart';
import '../modules/adminanalytics/views/adminanalytics_view.dart';
import '../modules/adminhistory/bindings/adminhistory_binding.dart';
import '../modules/adminhistory/views/adminhistory_view.dart';
import '../modules/adminhome/bindings/adminhome_binding.dart';
import '../modules/adminhome/views/adminhome_view.dart';
import '../modules/adminorder/bindings/adminorder_binding.dart';
import '../modules/adminorder/views/adminorder_view.dart';
import '../modules/article_detail/bindings/article_detail_binding.dart';
import '../modules/article_detail/views/article_detail_view.dart';
import '../modules/article_detail/views/article_detail_web_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/createbubuk/bindings/createbubuk_binding.dart';
import '../modules/createbubuk/views/createbubuk_view.dart';
import '../modules/createminuman/bindings/createminuman_binding.dart';
import '../modules/createminuman/views/createminuman_view.dart';
import '../modules/deleteacc/bindings/deleteacc_binding.dart';
import '../modules/deleteacc/views/deleteacc_view.dart';
import '../modules/detail_bubuk/bindings/detail_bubuk_binding.dart';
import '../modules/detail_bubuk/views/detail_bubuk_view.dart';
import '../modules/detail_minuman/bindings/detail_minuman_binding.dart';
import '../modules/detail_minuman/views/detail_minuman_view.dart';
import '../modules/forgotpw/bindings/forgotpw_binding.dart';
import '../modules/forgotpw/views/forgotpw_view.dart';
import '../modules/getconnect/bindings/getconnect_binding.dart';
import '../modules/getconnect/views/getconnect_view.dart';
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
import '../modules/myanalitics/bindings/myanalitics_binding.dart';
import '../modules/myanalitics/views/myanalitics_view.dart';
import '../modules/myfav/bindings/myfav_binding.dart';
import '../modules/myfav/views/myfav_view.dart';
import '../modules/myhistory/bindings/myhistory_binding.dart';
import '../modules/myhistory/views/myhistory_view.dart';
import '../modules/myorder/bindings/myorder_binding.dart';
import '../modules/myorder/views/myorder_view.dart';

import '../modules/ourlocation/bindings/ourlocation_binding.dart';
import '../modules/ourlocation/views/ourlocation_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/resetpw/bindings/resetpw_binding.dart';
import '../modules/resetpw/views/resetpw_view.dart';
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
      name: _Paths.DETAIL_BUBUK,
      page: () => DetailBubukView(
        description: '',
        harga1000gr: 0,
        harga100gr: 0,
        harga200gr: 0,
        harga300gr: 0,
        harga500gr: 0,
        imageUrl: '',
        location: '',
        name: '',
        status: true,
      ),
      binding: DetailBubukBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_MINUMAN,
      page: () => DetailMinumanView(
        description: '',
        hargalarge: 0,
        hargasmall: 0,
        imageUrl: '',
        location: '',
        name: '',
        status: true,
      ),
      binding: DetailMinumanBinding(),
    ),
    GetPage(
      name: _Paths.MAINPROFILE,
      page: () => MainprofileView(),
      binding: MainprofileBinding(),
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
      name: _Paths.RESETPW,
      page: () => ResetpwView(),
      binding: ResetpwBinding(),
    ),
    GetPage(
      name: _Paths.DELETEACC,
      page: () => DeleteaccView(),
      binding: DeleteaccBinding(),
    ),
    GetPage(
      name: _Paths.ADMINHOME,
      page: () => AdminhomeView(),
      binding: AdminhomeBinding(),
    ),
    GetPage(
      name: _Paths.ADMINORDER,
      page: () => AdminorderView(),
      binding: AdminorderBinding(),
    ),
    GetPage(
      name: _Paths.ADMINHISTORY,
      page: () => AdminhistoryView(),
      binding: AdminhistoryBinding(),
    ),
    GetPage(
      name: _Paths.CREATEMINUMAN,
      page: () => CreateminumanView(isEdit: false),
      binding: CreateminumanBinding(),
    ),
    GetPage(
      name: _Paths.CREATEBUBUK,
      page: () => CreatebubukView(isEdit: false),
      binding: CreatebubukBinding(),
    ),
    GetPage(
      name: _Paths.MYHISTORY,
      page: () => MyhistoryView(),
      binding: MyhistoryBinding(),
    ),
    GetPage(
      name: _Paths.ADMINANALYTICS,
      page: () => AdminanalyticsView(),
      binding: AdminanalyticsBinding(),
    ),
    GetPage(
      name: _Paths.MYANALITICS,
      page: () => MyanaliticsView(),
      binding: MyanaliticsBinding(),
    ),
    GetPage(
      name: _Paths.FORGOTPW,
      page: () => ForgotpwView(),
      binding: ForgotpwBinding(),
    ),
    GetPage(
      name: _Paths.GETCONNECT,
      page: () => const GetconnectView(),
      binding: GetconnectBinding(),
    ),
    GetPage(
      name: _Paths.ARTICLE_DETAIL,
      page: () => ArticleDetailView(article: Get.arguments),
      binding: ArticleDetailBinding(),
    ),
    GetPage(
        name: _Paths.ARTICLE_DETAIL_WEBVIEW,
        page: () => ArticleDetailWebView(article: Get.arguments),
        binding: ArticleDetailBinding()),
    GetPage(
      name: _Paths.OURLOCATION,
      page: () => OurlocationView(),
      binding: OurlocationBinding(),
    ),
  ];
}
