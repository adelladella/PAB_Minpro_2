import 'package:flutter/material.dart';
import 'package:prelove_notes/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'controllers/theme_controller.dart';
import 'package:get/get.dart';
import 'pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  Get.put(ThemeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,

        themeMode: themeController.isDark.value
            ? ThemeMode.dark
            : ThemeMode.light,

        theme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
          scaffoldBackgroundColor: const Color(0xFFF5E6D3),
          iconTheme: const IconThemeData(color: Color(0xFF5C4033)),
          cardColor: Colors.white,
          brightness: Brightness.light,
        ),

        darkTheme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
          scaffoldBackgroundColor: const Color(0xFF3B1F1A),
          iconTheme: const IconThemeData(color: Color(0xFFF5E6D3)),
          cardColor: const Color(0xFF4A2A24),
          brightness: Brightness.dark,
        ),

        home: const SplashPage(),
      ),
    );
  }
}
