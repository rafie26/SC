import 'package:get/get.dart';

import '../modules/TambahKelas/bindings/tambah_kelas_binding.dart';
import '../modules/TambahKelas/views/tambah_kelas_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home_guru/bindings/home_guru_binding.dart';
import '../modules/home_guru/views/home_guru_view.dart';
import '../modules/kelas/bindings/kelas_binding.dart';
import '../modules/kelas/views/kelas_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/navbar/bindings/navbar_binding.dart';
import '../modules/navbar/views/navbar_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.HOME_GURU,
      page: () => const HomeGuruView(),
      binding: HomeGuruBinding(),
    ),
    GetPage(
      name: Routes.TAMBAH_KELAS,
      page: () => const TambahKelasView(),
      binding: TambahKelasBinding(),
    ),
    GetPage(
      name: Routes.KELAS,
      page: () => const KelasView(),
      binding: KelasBinding(),
    ),
    GetPage(
      name: Routes.NAVBAR,
      page: () => const NavbarView(),
      binding: NavbarBinding(),
    ),
  ];
}
