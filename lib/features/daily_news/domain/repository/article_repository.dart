import 'package:note_ring/core/resouces/data_state.dart';
import 'package:note_ring/features/daily_news/domain/entities/article.dart';

abstract class ArticleRepository{

  ///api method
  Future<DataState<List<ArticleEntity>>> getNewsArticles();
  Future<List<ArticleEntity>> getSavedArticles();
  Future<void> saveArticles(ArticleEntity article);
  Future<void> removeArticles(ArticleEntity article);
}