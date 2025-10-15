import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:note_ring/features/daily_news/data/data_source/local/app_database.dart';
import 'package:note_ring/features/daily_news/data/data_source/remote/news_api_service.dart';
import 'package:note_ring/features/daily_news/data/repository/article_repository.dart';
import 'package:note_ring/features/daily_news/domain/repository/article_repository.dart';
import 'package:note_ring/features/daily_news/domain/usecases/get_article.dart';
import 'package:note_ring/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:note_ring/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';

import 'features/daily_news/domain/usecases/get__saved_article.dart';
import 'features/daily_news/domain/usecases/remove_article.dart';
import 'features/daily_news/domain/usecases/save_article.dart';

final sl = GetIt.instance; //service localtor

Future<void> initializeDependencies() async{

  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  sl.registerSingleton<AppDatabase>(database);
  //dio
  sl.registerSingleton<Dio>(Dio());

  //Dependency
  sl.registerSingleton<NewsApiService>(NewsApiService(sl()));

  sl.registerSingleton<ArticleRepository>(
    ArticleRepositoryImpl(sl(),sl())
  );

  //use case
  sl.registerSingleton<GetArticleUseCase>(GetArticleUseCase(sl()));
  sl.registerSingleton<GetSavedArticleUseCase>(GetSavedArticleUseCase(sl()));
  sl.registerSingleton<SaveArticleUseCase>(SaveArticleUseCase(sl()));
  sl.registerSingleton<RemoveArticleUseCase>(RemoveArticleUseCase(sl()));

  //blocs
  sl.registerFactory<RemoteArticleBloc>(() => RemoteArticleBloc(sl()));

  sl.registerFactory<LocalArticleBloc>(() => LocalArticleBloc(sl(),sl(),sl()));
}