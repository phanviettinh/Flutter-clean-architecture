import 'package:note_ring/core/resouces/data_state.dart';
import 'package:note_ring/core/usecase/usecase.dart';
import 'package:note_ring/features/daily_news/domain/entities/article.dart';
import 'package:note_ring/features/daily_news/domain/repository/article_repository.dart';

class GetArticleUseCase implements UseCase<DataState<List<ArticleEntity>>, void>{
  final ArticleRepository _articleRepository;


  GetArticleUseCase(this._articleRepository);


  @override
  Future<DataState<List<ArticleEntity>>> call({void params}) {
    // TODO: implement call
    return _articleRepository.getNewsArticles() ;
  }

}