import 'package:note_ring/core/resouces/data_state.dart';
import 'package:note_ring/features/daily_news/domain/entities/article.dart';

abstract class ArticleRepository{

  Future<DataState<List<ArticleEntity>>> getNewsArticles();
}