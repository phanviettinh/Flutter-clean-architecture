import 'dart:io';
import 'package:dio/dio.dart';
import 'package:note_ring/core/constants/constants.dart';
import 'package:note_ring/core/resouces/data_state.dart';
import 'package:note_ring/features/daily_news/data/data_source/remote/news_api_service.dart';
import 'package:note_ring/features/daily_news/data/models/article.dart';
import 'package:note_ring/features/daily_news/domain/entities/article.dart';
import '../../domain/repository/article_repository.dart';
import '../data_source/local/app_database.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;
  final AppDatabase _appDatabase;

  ArticleRepositoryImpl(this._newsApiService, this._appDatabase);

  /// 📰 Lấy danh sách bài báo từ API
  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      final httpResponse = await _newsApiService.getNewsArticle(
        apiKey: newsAPIKey,
        country: countryQuery,
        category: categoryQuery,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final articles = httpResponse.data.articles;
        return DataSuccess(articles);
      } else {
        return DataFailed(
          DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.badResponse,
            requestOptions: httpResponse.response.requestOptions,
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    } catch (e) {
      return DataFailed(
        DioException(
          error: e.toString(),
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  /// 💾 Lấy danh sách bài báo đã lưu
  @override
  Future<List<ArticleEntity>> getSavedArticles() async {
    final models = await _appDatabase.articleDao.getArticles();
    return models;
  }

  /// 🗑️ Xóa bài báo đã lưu theo URL
  @override
  Future<void> removeArticles(ArticleEntity article) async {
    if (article.url == null) return;
    await _appDatabase.articleDao.deleteArticleByUrl(article.url!);
  }

  /// 💖 Lưu bài báo
  @override
  Future<void> saveArticles(ArticleEntity article) async {
    // Ép sang ArticleModel để lưu
    final model = ArticleModel.fromEntity(article);
    await _appDatabase.articleDao.insertArticle(model);
  }
}
