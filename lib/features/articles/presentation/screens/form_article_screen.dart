import 'package:flutter/material.dart';
import 'package:ruang_sehat/theme/app_colors.dart';
import 'package:ruang_sehat/features/articles/presentation/widgets/image_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ruang_sehat/features/articles/providers/articles_provider.dart';
import 'package:ruang_sehat/utils/snackbar_helper.dart';

class FormArticleScreen extends StatefulWidget {
  const FormArticleScreen ({super.key});

  static const routeName = '/form-articles';

  @override
  State<FormArticleScreen> createState() => _formArticleScreenState();
}

class _formArticleScreenState extends State<FormArticleScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  String? imagePath;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final PickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (PickedFile != null){
      setState(() {
        imagePath = PickedFile.path;
      });
    }
  }

  Future<void> handleSubmit(bool isEdit, String? articleId) async {
    final provider = context.read<ArticlesProvider>();

    // validasi image hanya saat create
    if (!isEdit && imagePath == null) {
      SnackbarHelper.show(
        context,
        message: "Pilih gambar terlebih dahulu",
        isError: true,
      );
      return;
    }
    
    if (isEdit){
      // validasi artikel id
      if (articleId == null){
        SnackbarHelper.show(
          context,
          message: "ID artikel tidak ditemukan",
          isError: true,
        );
        return;
      }

      await provider.updateArticle(
        articleId,
        title: titleController.text,
        description: descriptionController.text,
        category: categoryController.text,
        ImagePath: imagePath,
      );
    } else {
      await provider.createArticle(
        titleController.text,
        descriptionController.text,
        categoryController.text,
        imagePath!
      );
    }

    if (!mounted) return;

    if (provider.errorMessage == null){
      SnackbarHelper.show(
        context,
        message: provider.successMessage ?? 'Succes',
        isError: false,
      );
      Navigator.pop(context);
    } else {
      SnackbarHelper.show(
        context,
        message: provider.successMessage ?? 'error',
        isError: true,
      );
    }
  }

  @override
  Widget build (BuildContext context){
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    final isEdit = args['isEdit'] ?? false;
    final articleId = args ['articleId'];
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            isEdit ? 'Update Artikel' : 'Create Artikel',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.background,
          leading: IconButton(
            padding: EdgeInsets.only(left: 20),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // image input
              ImageInput(onTap: _pickImage, imagePath: imagePath),
              const SizedBox(height: 20),
              // label form title
              Text(
                'Title',
                style: TextStyle(
                  color: Color(0XFF4D4637),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // form title
              const SizedBox(height: 5),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  fillColor: AppColors.secondary,
                  filled: true,
                  hintText: 'Enter the Article Title',
                  isDense: true,
                  hintStyle: const TextStyle(
                    color: AppColors.hintText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 15,
                  )
                ),
              ),
              // label form category
              const SizedBox(height: 10),
              Text(
                'Category',
                style: TextStyle(
                  color: Color(0XFF4D4637),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // form category
              const SizedBox(height: 5),
              TextFormField(
                controller: categoryController,
                decoration: InputDecoration(
                  fillColor: AppColors.secondary,
                  filled: true,
                  hintText: 'Enter the Article Category',
                  isDense: true,
                  hintStyle: const TextStyle(
                    color: AppColors.hintText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 15,
                  )
                ),
              ),
              // label form description
              const SizedBox(height: 10),
              Text(
                'Description',
                style: TextStyle(
                  color: Color(0XFF4D4637),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // form description
              const SizedBox(height: 5),
              TextFormField(
                maxLines: 8,
                minLines: 8,
                keyboardType: TextInputType.multiline,
                controller: descriptionController,
                decoration: InputDecoration(
                  fillColor: AppColors.secondary,
                  filled: true,
                  hintText: 'Enter the Article Description',
                  isDense: true,
                  hintStyle: const TextStyle(
                    color: AppColors.hintText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 15,
                  )
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () async {
              handleSubmit(isEdit, isEdit ? articleId : null);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
            ),
            child: Text(
              isEdit ? 'Update' : 'Create',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}