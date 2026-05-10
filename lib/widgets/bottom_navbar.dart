import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruang_sehat/features/home/screens/home_screen.dart';
import 'package:ruang_sehat/features/articles/presentation/screens/my_articles_screen.dart';
import 'package:ruang_sehat/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ruang_sehat/features/articles/providers/articles_provider.dart';
import 'package:ruang_sehat/features/auth/providers/auth_provider.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar ({super.key});

  static const routeName = '/bottom-navbar';

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

  class _BottomNavbarState extends State<BottomNavbar>{
    int _selectedIndex = 0;
    bool _isFirstLoad = true;
    List<Widget> get _pages => [HomeScreen(), MyArticlesScreen()];

    @override
    void initState() {
      super.initState();
      Future.microtask(() {
        final articleProvider = context.read<ArticlesProvider>();
        final authProvider = context.read<AuthProvider>();
        articleProvider.getArticles();
        articleProvider.getMyArticles();
        authProvider.getProfile();
      });
    }

    @override
    void didChangeDependencies(){
      super.didChangeDependencies();

      if (_isFirstLoad){
        final args = ModalRoute.of(context)?.settings.arguments;
        if (args != null && args is int){
          _selectedIndex = args;
        }
        _isFirstLoad = false;
      }
    }

    @override
    Widget build(BuildContext context){
      return Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.secondary,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.hintText,
          currentIndex: _selectedIndex,
          iconSize: 20,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.house),
              label: 'Home',
            ),
            BottomNavigationBarItem(icon: Icon(LucideIcons.newspaper),
            label: 'My Articles',
            ),
          ],
        ),
      );
    }
  }