import 'package:flutter/material.dart';
import 'package:ruang_sehat/features/articles/presentation/widgets/container_detail.dart';
import 'package:ruang_sehat/theme/app_colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:ruang_sehat/features/articles/providers/articles_provider.dart';
import 'package:ruang_sehat/features/articles/presentation/widgets/popup_menu.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen ({super.key});

  static const routeName = '/detail-article';

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  static final String baseUrl = dotenv.env['BASE_URL']!;
  bool isMenuOpen = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      final id = args['id'];

      context.read<ArticlesProvider>().getDetailArticle(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    final isMe = args['isMe'] ?? false;
    final provider = context.watch<ArticlesProvider>();

    if (provider.isLoading){
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.detailArticle == null){
      return const Center(child: Text("Tidak ada artikel"));
    }

    final article = provider.detailArticle!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // image artikel
            Image(
              image: NetworkImage("$baseUrl/${article.image}"),
              width: double.infinity,
              height: 500,
              fit: BoxFit.cover,
            ),
            // gradient overlay
            Align(
              alignment: AlignmentGeometry.topCenter,
              child: Container(
                height: 500,
                width: double.infinity,
                decoration: BoxDecoration(gradient: LinearGradient(
                  begin: AlignmentGeometry.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    AppColors.background.withOpacity(
                      1.0,
                    ), // bagian bawah lebih solid
                    AppColors.background.withOpacity(
                      0.0,
                    ), // bagian atas transparan
                  ],
                )
                ),
              ),
            ),
            // container detail
            Positioned(
              left: 20,
              right: 20,
              top: 0,
              bottom: 0,
              child: ContainerDetail(article: article),
            ),
            // back button
            Positioned(
              top: 25,
              left: 25,
              right: 25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.text.withOpacity(0.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsGeometry.only(left: 7),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.secondary,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                  if (isMe)
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.text.withOpacity(0.3),
                    ),
                    child: IconButton(
                      onPressed: () => {
                        setState(() => isMenuOpen = !isMenuOpen),
                      },
                      icon: const Icon(
                        Icons.more_horiz,
                        color: AppColors.secondary,
                        size: 25,
                      )
                    ),
                  )
                ],
              ),
            ),
            // popup menu
            if (isMenuOpen) ...[
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isMenuOpen = false;
                    });
                  },
                  child: Container(color: Colors.transparent),
                ),
              ),
              Positioned(
                top: 80,
                right: 20,
                child: PopupMenu(articleId: article.id),
              ),
            ],
          ],
        ),
      ),
    );
  }
}