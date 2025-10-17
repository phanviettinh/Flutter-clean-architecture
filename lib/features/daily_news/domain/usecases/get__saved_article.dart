import 'package:note_ring/features/daily_news/domain/entities/article.dart';
import 'package:note_ring/features/daily_news/domain/repository/article_repository.dart';

import '../../../../core/usecase/usecase.dart';

class GetSavedArticleUseCase implements UseCase<List<ArticleEntity>,void>{
  final ArticleRepository _articleRepository;

  GetSavedArticleUseCase(this._articleRepository);

  @override
  Future<List<ArticleEntity>> call({params}) {
    // TODO: implement call
    return _articleRepository.getSavedArticles();
  }
}