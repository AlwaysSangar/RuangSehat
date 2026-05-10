import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:ruang_sehat/features/articles/presentation/screens/form_article_screen.dart';
import 'package:ruang_sehat/widgets/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:ruang_sehat/features/articles/providers/articles_provider.dart';
import 'package:ruang_sehat/utils/snackbar_helper.dart';
import 'package:ruang_sehat/widgets/bottom_navbar.dart';

class PopupMenu extends StatelessWidget {
  final String articleId;

  const PopupMenu({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: 180,
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text(
                  'Edit Article',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    FormArticleScreen.routeName,
                    arguments: {'isEdit': true, 'articleId': articleId},
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Delete Article',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  ModalBottomSheet.show(
                    context: context,
                    label: 'Are you sure you want to delete article?',
                    isLogout: false,
                    onConfirm: () async {
                      final articleProvider = context.read<ArticlesProvider>();
                      final navigator = Navigator.of(context);

                      // tutup bottom sheet
                      navigator.pop();

                      await articleProvider.deleteArticle(articleId);

                      if (articleProvider.errorMessage == null) {
                        SnackbarHelper.show(
                          navigator.context,
                          message: articleProvider.successMessage ?? 'Succes',
                          isError: false,
                        );
                        
                        navigator.pushNamedAndRemoveUntil(
                          BottomNavbar.routeName,
                          (route) => false,
                          arguments: 1,
                        );
                      } else {
                        SnackbarHelper.show(
                          navigator.context,
                          message: articleProvider.errorMessage ?? 'error',
                          isError: true,
                        );
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}