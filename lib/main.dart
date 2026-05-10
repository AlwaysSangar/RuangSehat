import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:ruang_sehat/features/auth/presentation/screens/auth_screen.dart';
import 'package:ruang_sehat/features/splash/splash_screen.dart';
import 'package:ruang_sehat/features/auth/providers/auth_provider.dart';
import 'package:ruang_sehat/features/home/screens/home_Screen.dart';
import 'package:ruang_sehat/widgets/bottom_navbar.dart';
import 'package:ruang_sehat/features/articles/providers/articles_provider.dart';
import 'package:ruang_sehat/features/articles/presentation/screens/detail_screen.dart';
import 'package:ruang_sehat/features/articles/presentation/screens/form_article_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => ArticlesProvider()),
    ],
    child: const MyApp(),
  ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Terapkan font Poppins sebagai font default untuk seluruh aplikasi
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),

      // Initial Route
      initialRoute: SplashScreen.routeName,

      // Daftar semua page
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        AuthScreen.routeName: (context) => const AuthScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        BottomNavbar.routeName: (context) => const BottomNavbar(),
        DetailScreen.routeName: (context) => const DetailScreen(),
        FormArticleScreen.routeName: (context) => const FormArticleScreen(),
      },
    );
  }
}