import 'package:flutter/material.dart';
import 'package:ruang_sehat/features/articles/data/articles_model.dart';
import 'package:ruang_sehat/theme/app_colors.dart';

class ContainerDetail extends StatelessWidget {
  final ArticlesModel article;

  const ContainerDetail ({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.35,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // label category
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  article.category,
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // title
              const SizedBox(height: 12),
              Text(
                article.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // date
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    article.name,
                    style: TextStyle(fontSize: 12, color: AppColors.hintText),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    article.date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.hintText,
                    ),
                  ),
                ],
              ),
              // garis pemisah
              const SizedBox(height: 8),
              const Divider(),
              // description
              const SizedBox(height: 8),
              Text(
                article.description,
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}