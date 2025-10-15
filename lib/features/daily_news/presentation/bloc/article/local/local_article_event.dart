import 'package:equatable/equatable.dart';
import 'package:note_ring/features/daily_news/domain/entities/article.dart';

 abstract class LocalArticlesEvent extends Equatable{
   final ArticleEntity? articleEntity;


   const LocalArticlesEvent(this.articleEntity);

  @override
  // TODO: implement props
  List<Object?> get props => [articleEntity];
}

class GetSavedArticles extends LocalArticlesEvent{
  const GetSavedArticles(super.articleEntity);
}
class SaveArticles extends LocalArticlesEvent{
  const SaveArticles(super.articleEntity);
}
class RemoveArticles extends LocalArticlesEvent{
  const RemoveArticles(super.articleEntity);
}