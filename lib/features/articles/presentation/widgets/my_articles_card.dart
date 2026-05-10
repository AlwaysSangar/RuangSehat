import 'package:flutter/material.dart';
import 'package:ruang_sehat/theme/app_colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:ruang_sehat/features/articles/providers/articles_provider.dart';
import 'package:ruang_sehat/features/articles/presentation/screens/detail_screen.dart';

class MyArticlesCard extends StatelessWidget {
  const MyArticlesCard({super.key});
  static final String baseUrl = dotenv.env['BASE_URL']!;

  @override
  Widget build (BuildContext context){
    return Consumer<ArticlesProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading){
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.myArticles.isEmpty){
          return const Center(child: Text("Tidak ada artikel"));
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.myArticles.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final myArticle = provider.myArticles[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  DetailScreen.routeName,
                  arguments: {'id': myArticle.id, 'isMe': true},
                );
              },
              child: Card(
                color: AppColors.secondary,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      // image artikel
                      Stack(
                        children: [
                          // container image
                          Container(
                            width: double.infinity,
                            height: 196,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(
                                    "$baseUrl/${myArticle.image}",
                                  ),
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                          // label category
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                'Healthy Tips',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),      
                      // title artikel
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            Text(
                              'Artikel ke $index',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.hintText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '2022-10-01',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.hintText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "The Benefits of running and Tips to Get Started",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]
                    ),
                  ),
                ],
               ),
              ),
                         ),
            );
          },
        );
      }
    );
  }
}