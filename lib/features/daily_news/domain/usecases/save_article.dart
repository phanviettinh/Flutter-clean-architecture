import 'package:note_ring/features/daily_news/domain/entities/article.dart';
import 'package:note_ring/features/daily_news/domain/repository/article_repository.dart';

import '../../../../core/usecase/usecase.dart';

class SaveArticleUseCase implements UseCase<void,ArticleEntity>{
  final ArticleRepository _articleRepository;

  SaveArticleUseCase(this._articleRepository);

  @override
  Future<void> call({ArticleEntity? params}) {
    // TODO: implement call
    return _articleRepository.saveArticles(params!);
  }

}