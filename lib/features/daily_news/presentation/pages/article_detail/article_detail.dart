import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:note_ring/features/daily_news/domain/entities/article.dart';
import 'package:note_ring/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:note_ring/features/daily_news/presentation/bloc/article/local/local_article_event.dart';

import '../../../../../core/widgets/custom_snackbar.dart';
import '../../../../../injection_container.dart';
import '../../bloc/article/local/local_article_state.dart';

class ArticleDetail extends HookWidget {
  final ArticleEntity? articleEntity;
  const ArticleDetail(this.articleEntity, {super.key});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => sl<LocalArticleBloc>(),

      child: Scaffold(
        appBar: _buildAppbar(context),
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButton(context), // FAB chính là nút save
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => _onBackButtonTapped(context),
      ),
      title: Text(
        articleEntity?.title ?? 'Article Details',
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleAndDate(),
          const SizedBox(height: 16),
          _buildImage(),
          const SizedBox(height: 16),
          _buildDescription(),
          const SizedBox(height: 16),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildTitleAndDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          articleEntity?.title ?? 'No title',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              articleEntity?.publishedAt?.substring(0, 10) ?? '',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Spacer(),
            Text(
              articleEntity?.author ?? 'Unknown author',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImage() {
    if (articleEntity?.urlToImage == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        articleEntity!.urlToImage!,
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mô tả:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          articleEntity?.description ?? 'No description available',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nội dung:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // Fix: Sử dụng SelectableText để chọn và copy được
        SelectableText(
          articleEntity?.content ?? 'No content available',
          style: const TextStyle(fontSize: 16),
          maxLines: null,
        ),
      ],
    );
  }

  // FAB - Nút Save chính
  Widget _buildFloatingActionButton(BuildContext context) {
    return BlocBuilder<LocalArticleBloc, LocalArticlesState>(
      builder: (context, state) {
        bool isSaved = state is LocalArticleDone &&
            state.articles?.any((a) => a.url == articleEntity?.url) == true;
        return FloatingActionButton(
          onPressed: () => _onFloatingActionButton(context, isSaved),
          backgroundColor: isSaved ? Colors.amber : Colors.blue,
          child: Icon(
            isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: Colors.white,
          ),
        );
      },
    );
  }
  void _onFloatingActionButton(BuildContext context, bool isSaved) {
    try {
      if (isSaved) {
        // Remove khỏi saved
        context.read<LocalArticleBloc>().add(RemoveArticles(articleEntity!));

        // SỬ DỤNG CUSTOM TOP NOTIFICATION CHO REMOVE
        showTopSnackbarNotification(
          context,
          'Đã xóa khỏi danh sách lưu',
          type: NotificationType.info, // Dùng NotificationType.info
        );
      } else {
        // Save bài báo
        context.read<LocalArticleBloc>().add(SaveArticles(articleEntity!));

        // SỬ DỤNG CUSTOM TOP NOTIFICATION CHO SAVE
        showTopSnackbarNotification(
          context,
          'Đã lưu bài báo thành công!',
          type: NotificationType.success, // Dùng NotificationType.success
        );
      }
    }catch(e){
      // Xử lý lỗi
      showTopSnackbarNotification(
        context,
        'Lỗi xảy ra khi thực hiện thao tác: ${e.toString()}',
        type: NotificationType.error,
        duration: const Duration(seconds: 5),
      );
    }
  }

  void _onBackButtonTapped(BuildContext context) {
    Navigator.pop(context);
  }
}