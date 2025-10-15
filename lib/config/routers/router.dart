import 'package:flutter/material.dart';
import '../../features/daily_news/domain/entities/article.dart';
import '../../features/daily_news/presentation/pages/article_detail/article_detail.dart';
import '../../features/daily_news/presentation/pages/home/daily_news.dart';
import '../../features/daily_news/presentation/pages/saved_article/saved_article.dart';


class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const DailyNews(),
          settings: settings,
        );
      case '/saved':
        return MaterialPageRoute(
          builder: (_) => const SavedArticle(),
          settings: settings,
        );
      case '/ArticleDetails':
        final article = settings.arguments as ArticleEntity?;
        return MaterialPageRoute(
          builder: (_) => ArticleDetail(article),
          settings: settings,
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found')),
      ),
      settings: const RouteSettings(name: '/error'),
    );
  }

  // Named routes helper methods
  static Future<void> goToHome(BuildContext context) {
    return Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  static Future<void> goToSavedArticles(BuildContext context) {
    return Navigator.of(context).pushNamed('/saved');
  }

  static Future<void> goToArticleDetail(BuildContext context, ArticleEntity article) {
    return Navigator.of(context).pushNamed('/ArticleDetails', arguments: article);
  }

  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void popUntilHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}