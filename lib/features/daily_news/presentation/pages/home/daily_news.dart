import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_ring/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:note_ring/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:url_launcher/url_launcher.dart';

class DailyNews extends StatelessWidget {
  const DailyNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      title: const Text(
        'Daily News',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 1,
    );
  }

  Widget _buildBody() {
    return BlocBuilder<RemoteArticleBloc, RemoteArticleState>(
      builder: (context, state) {
        if (state is RemoteArticleLoading) {
          return const Center(child: CupertinoActivityIndicator());
        }

        if (state is RemoteArticleError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 10),
                Text(
                  state.error?.message ?? 'Something went wrong',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Bạn có thể dispatch lại event GetArticles tại đây
                    // context.read<RemoteArticleBloc>().add(GetArticles());
                  },
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        if (state is RemoteArticleDone) {
          final articles = state.articles;

          if (articles!.isEmpty) {
            return const Center(child: Text('No articles found'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              // context.read<RemoteArticleBloc>().add(GetArticles());
            },
            child: ListView.builder(
              itemCount: articles.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final article = articles[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      if (article.url != null) {
                        launchUrl(Uri.parse(article.url!));
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ảnh
                        article.urlToImage != null
                            ? Image.network(
                          article.urlToImage!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image, size: 80),
                        )
                            : Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: const Center(
                              child: Icon(Icons.image_not_supported,
                                  size: 50)),
                        ),
                        // Nội dung
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.title ?? 'No title',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                article.description ?? '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    article.author ?? 'Unknown author',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    article.publishedAt?.substring(0, 10) ??
                                        '',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
