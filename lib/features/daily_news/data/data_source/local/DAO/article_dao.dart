import 'package:floor/floor.dart';
import '../../../models/article.dart';

@dao
abstract class ArticleDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertArticle(ArticleModel article);

  @Query('DELETE FROM article WHERE url = :url')
  Future<void> deleteArticleByUrl(String url);

  @Query('SELECT * FROM article WHERE url = :url')
  Future<ArticleModel?> getArticleByUrl(String url);

  @Query('SELECT * FROM article')
  Future<List<ArticleModel>> getArticles();
}
