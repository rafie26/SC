import 'package:get/get.dart';

import '../modules/TambahKelas/bindings/tambah_kelas_binding.dart';
import '../modules/TambahKelas/views/tambah_kelas_view.dart';
import '../modules/cerita/bindings/cerita_binding.dart';
import '../modules/cerita/views/cerita_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home_guru/bindings/home_guru_binding.dart';
import '../modules/home_guru/views/home_guru_view.dart';
import '../modules/kalender/bindings/kalender_binding.dart';
import '../modules/kalender/views/kalender_view.dart';
import '../modules/kelas/bindings/kelas_binding.dart';
import '../modules/kelas/views/kelas_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/materi/bindings/materi_binding.dart';
import '../modules/materi/views/materi_view.dart';
import '../modules/navbar/bindings/navbar_binding.dart';
import '../modules/navbar/views/navbar_view.dart';
import '../modules/notifikasi/bindings/notifikasi_binding.dart';
import '../modules/notifikasi/views/notifikasi_view.dart';
import '../modules/obrolan/bindings/obrolan_binding.dart';
import '../modules/obrolan/views/obrolan_view.dart';
import '../modules/profil/bindings/profil_binding.dart';
import '../modules/profil/views/profil_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/ruang_chat/bindings/ruang_chat_binding.dart';
import '../modules/ruang_chat/views/ruang_chat_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/tugas/bindings/tugas_binding.dart';
import '../modules/tugas/views/tugas_view.dart';
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
    GetPage(
      name: Routes.CERITA,
      page: () => const CeritaView(),
      binding: CeritaBinding(),
    ),
    GetPage(
      name: Routes.OBROLAN,
      page: () => const ObrolanView(),
      binding: ObrolanBinding(),
    ),
    GetPage(
      name: Routes.NOTIFIKASI,
      page: () => const NotifikasiView(),
      binding: NotifikasiBinding(),
    ),
    GetPage(
      name: Routes.TUGAS,
      page: () => const TugasView(),
      binding: TugasBinding(),
    ),
    GetPage(
      name: Routes.MATERI,
      page: () => const MateriView(),
      binding: MateriBinding(),
    ),
    GetPage(
      name: Routes.KALENDER,
      page: () => const KalenderView(),
      binding: KalenderBinding(),
    ),
    GetPage(
      name: Routes.PROFIL,
      page: () => const ProfilView(),
      binding: ProfilBinding(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: Routes.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: Routes.RUANG_CHAT,
      page: () => const RuangChatView(),
      binding: RuangChatBinding(),
    ),
  ];
}
