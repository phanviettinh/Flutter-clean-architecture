import 'package:equatable/equatable.dart';
import 'package:note_ring/features/daily_news/domain/entities/article.dart';

abstract class LocalArticlesState extends Equatable{
  final List<ArticleEntity>? articles;
  const LocalArticlesState({this.articles});
  @override
  // TODO: implement props
  List<Object?> get props => [articles];
}

class LocalArticleLoading extends LocalArticlesState{
  const LocalArticleLoading();
}

class LocalArticleDone extends LocalArticlesState{
  const LocalArticleDone(List<ArticleEntity> articles) : super(articles: articles);
}
