import 'package:note_ring/core/resouces/data_state.dart';
import 'package:note_ring/features/daily_news/domain/usecases/get_article.dart';
import 'package:note_ring/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:note_ring/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class RemoteArticleBloc extends Bloc<RemoteArticleEvent,RemoteArticleState>{

  final GetArticleUseCase _getArticleUseCase;
  RemoteArticleBloc(this._getArticleUseCase) : super(RemoteArticleLoading()){
    on<GetArticles>(onGetArticle);
  }


  onGetArticle(GetArticles event, Emitter<RemoteArticleState> emit) async{

    final dataState = await  _getArticleUseCase();
    if(dataState is DataSuccess && dataState.data!.isNotEmpty){
      emit(RemoteArticleDone(dataState.data!));
    }

    if(dataState is DataFailed){
      emit(RemoteArticleError(dataState.error!));
    }
  }

}