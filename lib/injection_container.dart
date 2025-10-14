import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:note_ring/features/daily_news/data/data_source/local/app_database.dart';
import 'package:note_ring/features/daily_news/data/data_source/remote/news_api_service.dart';
import 'package:note_ring/features/daily_news/data/repository/article_repository.dart';
import 'package:note_ring/features/daily_news/domain/repository/article_repository.dart';
import 'package:note_ring/features/daily_news/domain/usecases/get_article.dart';
import 'package:note_ring/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';

final sl = GetIt.instance; //service localtor

Future<void> initializeDependencies() async{

  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  //dio
  sl.registerSingleton<Dio>(Dio());

  //Dependency
  sl.registerSingleton<NewsApiService>(NewsApiService(sl()));

  sl.registerSingleton<ArticleRepository>(
    ArticleRepositoryImpl(sl())
  );

  //use case
  sl.registerSingleton<GetArticleUseCase>(GetArticleUseCase(sl()));

  //blocs
  sl.registerFactory<RemoteArticleBloc>(() => RemoteArticleBloc(sl()));
}