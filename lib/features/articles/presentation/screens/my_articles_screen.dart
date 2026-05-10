import 'package:flutter/material.dart';
import 'package:ruang_sehat/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ruang_sehat/features/articles/presentation/widgets/my_articles_card.dart';
import 'package:provider/provider.dart';
import 'package:ruang_sehat/features/articles/providers/articles_provider.dart';
import 'package:ruang_sehat/features/articles/presentation/screens/form_article_screen.dart';

class MyArticlesScreen extends StatelessWidget {
  const MyArticlesScreen({super.key});

  @override
  Widget build (BuildContext context){
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Articles',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '10 items',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.hintText,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16),

                MyArticlesCard(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            FormArticleScreen.routeName,
            arguments: {'isEdit': false},
          );
        },
        backgroundColor: AppColors.primary,
        shape: CircleBorder(),
        child: Icon(LucideIcons.plus, color: Colors.white, size: 30),
      ),
    );
  }
}