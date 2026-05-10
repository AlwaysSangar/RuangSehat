import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ruang_sehat/features/articles/data/articles_model.dart';
import 'package:ruang_sehat/features/articles/data/articles_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArticlesProvider with ChangeNotifier {
  List<ArticlesModel> _articles = [];
  List<ArticlesModel> _myArticles = [];
  ArticlesModel? _detailArticle;
  List<ArticlesModel> _featuredArticles = [];

  bool _isLoading = false;
  String? _errorMessage;
  String? _succesMessage;
  bool _isFetchingMore = false;
  int _currentPage = 1;
  bool _hasNextPage = true;

  //Getter 
  List<ArticlesModel> get articles => _articles;
  List<ArticlesModel> get myArticles => _myArticles;
  ArticlesModel? get detailArticle => _detailArticle;
  List<ArticlesModel> get featuredArticles => _featuredArticles;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _succesMessage;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasNextPage => _hasNextPage;

  // get all article
  Future<void> getArticles({bool isRefresh = true}) async {
    if (isRefresh){
      _currentPage = 1;
      _hasNextPage = true;
      _setLoading(true);
    } else {
      if (!_hasNextPage || _isFetchingMore) return;
      _setFetchingMore(true);
    }

    _resetMessage();

    try {
      final result = await ArticlesServices.gerArticles(
        page: _currentPage,
        limit: 5,
      );

      final List<ArticlesModel> data = result['articles'];
      final int totalPages = result['totalPages'];

      if (isRefresh){
        _articles = data;

        // ambil data dari halaman terakhir untuk featured
        if (totalPages > 1){
          final lastPageData = await ArticlesServices.gerArticles(
            page: totalPages,
            limit: 5,
          );
          final List<ArticlesModel> lastPageArticles = lastPageData['articles'];
          _featuredArticles = lastPageArticles;
        } else {
          // jika hanya ada 1 halaman, ambil data terbawah dari halaman tersebut
          _featuredArticles = data.length > 5
            ? data.sublist(data.length - 5)
            : List.from(data);
        }
      } else {
        // tambahkan data baru ke list recomended
        _articles.addAll(data);
      }

      // atur status halaman berikutnya
      if (data.isEmpty || data.length < 5){
        _hasNextPage = false;
      } else {
        _currentPage++;
      }

      if (result.isEmpty && isRefresh) {
        _errorMessage = "Data artikel kosong";
      }
    } catch (err) {
      _errorMessage = _parseError(err);
      if (isRefresh) _articles = [];
    } finally {
      if (isRefresh) {
      _setLoading(false);
    } else {
      _setFetchingMore(false);
    }
  }
}

  // get my article
  Future<void> getMyArticles() async {
    _setLoading(true);
    _resetMessage();

    try {
      final result = await ArticlesServices.getMyArticles();

      _myArticles = result;
      
      if (result.isEmpty){
        _errorMessage = "Data artikel kosong";
      }
    } catch (err) {
      _errorMessage = _parseError(err);
      _myArticles = [];
    } finally {
      _setLoading(false);
    }
  }

  // get detail article
  Future<void> getDetailArticle(String id) async {
    _setLoading(true);
    _resetMessage();

  try {
    final result = await ArticlesServices.getDetailArticle(id);

    _detailArticle = result;
  } catch (e) {
    _errorMessage = _parseError(e);
    _detailArticle = null;
  } finally {
    _setLoading(false);
  }
}

  // create artikel
  Future<void> createArticle(
    String title,
    String description,
    String category,
    String ImagePath,
  ) async {
    _setLoading(true);
    _resetMessage();

    try {
      final StreamedRequest = await ArticlesServices.createArtikel(
        File(ImagePath),
        title,
        description,
        category,
      );

      final response = await http.Response.fromStream(StreamedRequest);

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200){
        await getMyArticles();
        await getArticles();
        _succesMessage = data ['message'] ?? 'artikel berhasil dibuat';
      } else if (response.statusCode == 400){
        final firstError = data ['errors'][0];
        _errorMessage = firstError['message'] ?? 'Terjadi Kesalahan';
      } else {
        _errorMessage = data['message'] ?? 'Terjadi Kesalahan';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan koneksi';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }
  
  // update article
  Future<void> updateArticle(
    String id, {
    String? title,
    String? description,
    String? category,
    String? ImagePath,
  }) async {
    _setLoading(true);
    _resetMessage();

    try {
      final StreamedRequest = await ArticlesServices.updateArtikel(
        id,
        title: title,
        description: description,
        category: category,
        image: ImagePath != null ? File(ImagePath) : null,
      );

      final response = await http.Response.fromStream(StreamedRequest);

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200){
        await getMyArticles();
        await getArticles();
        await getDetailArticle(id);
        _succesMessage = data ['message'] ?? 'artikel berhasil diperbarui';
      } else if (response.statusCode == 400){
        final firstError = data ['errors'][0];
        _errorMessage = firstError['message'] ?? 'Terjadi Kesalahan';
      } else {
        _errorMessage = data['message'] ?? 'Terjadi Kesalahan';

      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan koneksi';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // delete artike
  Future<void> deleteArticle(String id) async {
    _setLoading(true);
    _resetMessage();

    try {
      final result = await ArticlesServices.deleteArtikel(id);

      final data = jsonDecode(result.body);

      if (result.statusCode == 200) {
        await getMyArticles();
        await getArticles();
        _succesMessage = data ['message'] ?? 'Artikel berhasil dihapus';
      } else if (result.statusCode == 400){
        final firstError = data ['errors'][0];
        _errorMessage = firstError ['message'] ?? "Terjadi kesalahan";
      } else {
        _errorMessage = data['message'] ?? 'Terjadi kesalahan';
      }
    } catch (e){
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }
  
  // Helper
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _resetMessage() {
    _errorMessage = null;
    _succesMessage = null;
  }

  String _parseError(Object e) {
    return e.toString().replaceAll('Exception: ', '');
  }

  void _setFetchingMore(bool value){
    _isFetchingMore = value;
    notifyListeners();
  }
}