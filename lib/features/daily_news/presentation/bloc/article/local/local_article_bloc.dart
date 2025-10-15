import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_ring/features/daily_news/domain/usecases/get__saved_article.dart';
import 'package:note_ring/features/daily_news/domain/usecases/remove_article.dart';
import 'package:note_ring/features/daily_news/domain/usecases/save_article.dart';
import 'package:note_ring/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:note_ring/features/daily_news/presentation/bloc/article/local/local_article_state.dart';

class LocalArticleBloc extends Bloc<LocalArticlesEvent,LocalArticlesState>{
  final GetSavedArticleUseCase _getSavedArticleUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final RemoveArticleUseCase _removeArticleUseCase;

  LocalArticleBloc(this._getSavedArticleUseCase, this._saveArticleUseCase,
      this._removeArticleUseCase) : super(LocalArticleLoading()){
    on<GetSavedArticles>(onGetSavedArticles);
    on<RemoveArticles>(onRemoveArticle);
    on<SaveArticles>(onSaveArticle);
  }

  void onGetSavedArticles(GetSavedArticles getSaveArticle,Emitter<LocalArticlesState> emit) async
  {
    final articles = await _getSavedArticleUseCase();
    emit(LocalArticleDone(articles));
  }

  void onRemoveArticle(RemoveArticles removeArticle,Emitter<LocalArticlesState> emit) async{
    await _removeArticleUseCase(params: removeArticle.articleEntity);
    final articles = await _getSavedArticleUseCase();
    emit(LocalArticleDone(articles));
  }

  void onSaveArticle(SaveArticles saveArticle,Emitter<LocalArticlesState> emit) async{
    await _saveArticleUseCase(params: saveArticle.articleEntity);
    final articles = await _getSavedArticleUseCase();
    emit(LocalArticleDone(articles));
  }


}