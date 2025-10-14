import 'package:dio/dio.dart';
import 'package:note_ring/core/constants/constants.dart';
import 'package:note_ring/features/daily_news/data/models/article.dart';
import 'package:retrofit/dio.dart' as io;
import 'package:retrofit/retrofit.dart';
part 'news_api_service.g.dart';

@RestApi(baseUrl: newsAPIBaseUrl)
abstract class NewsApiService {
  factory NewsApiService(Dio dio, {String baseUrl}) = _NewsApiService;

  @GET('/top-headlines')
  Future<io.HttpResponse<NewsResponse>> getNewsArticle({
    @Query('apiKey') String? apiKey,
    @Query('country') String? country,
    @Query('category') String? category,
  });

}
