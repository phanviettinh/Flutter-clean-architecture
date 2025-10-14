import 'dart:io';
import 'package:dio/dio.dart';
import 'package:note_ring/core/constants/constants.dart';
import 'package:note_ring/core/resouces/data_state.dart';
import 'package:note_ring/features/daily_news/data/data_source/remote/news_api_service.dart';
import 'package:note_ring/features/daily_news/data/models/article.dart';
import '../../domain/repository/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;

  ArticleRepositoryImpl(this._newsApiService);

  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      final httpResponse = await _newsApiService.getNewsArticle(
        apiKey: newsAPIKey,
        country: countryQuery,
        category: categoryQuery,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        // Lấy danh sách articles từ wrapper NewsResponse
        final articles = httpResponse.data.articles;
        print('articles: $articles');

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
}
