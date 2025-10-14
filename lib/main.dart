import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_ring/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:note_ring/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:note_ring/features/daily_news/presentation/pages/home/daily_news.dart';

import 'config/theme/app_theme.dart';
import 'injection_container.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const MyApp());
}

// MyApp bây giờ là StatelessWidget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoteArticleBloc>(
      create: (context) => sl()..add(const GetArticles()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme(),
        home:  DailyNews(),
      ),
    );
  }

}

