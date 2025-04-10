import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_mobile/models/post_model.dart';
import 'package:im_mobile/providers/post_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimelinePage extends ConsumerStatefulWidget {
  const TimelinePage({super.key});

  @override
  ConsumerState<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends ConsumerState<TimelinePage> {
  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(timelinePostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('好友动态'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push('/create-post');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(timelinePostsProvider.notifier).refresh(),
        child: postsAsync.when(
          data: (posts) {
            if (posts.isEmpty) {
              return ListView(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      child: Text('暂无动态，下拉刷新试试'))
                ],
              );
            }
            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(
                  post: post,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/post-detail',
                      arguments: post.id,
                    );
                  },
                  onLike: () {
                    ref
                        .read(timelinePostsProvider.notifier)
                        .toggleLike(post.id);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(height: 20,);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('加载失败，请重试'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(timelinePostsProvider.notifier).refresh(),
                  child: const Text('重新加载'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onTap;
  final VoidCallback onLike;

  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 用户信息
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: post.avatar != null
                        ? NetworkImage(post.avatar!)
                        : const AssetImage('assets/images/default_avatar.png')
                            as ImageProvider,
                    radius: 20,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.nickname ?? post.username ?? '用户',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        timeago.format(
                            DateTime.fromMillisecondsSinceEpoch(
                                post.createdAt * 1000),
                            locale: 'zh_CN'),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // 动态内容
              Text(post.content),
              const SizedBox(height: 12),
              // 媒体内容
              if (post.medias != null && post.medias!.isNotEmpty)
                MediaGrid(medias: post.medias!),
              const SizedBox(height: 8),
              // 点赞按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      post.liked == true
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: post.liked == true ? Colors.red : null,
                    ),
                    onPressed: onLike,
                  ),
                  Text('${post.likeCount}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MediaGrid extends StatelessWidget {
  final List<MediaModel> medias;

  const MediaGrid({super.key, required this.medias});

  @override
  Widget build(BuildContext context) {
    // 根据媒体数量决定布局
    if (medias.isEmpty) return const SizedBox.shrink();

    // 最多显示9张图片
    final displayMedias = medias.length > 9 ? medias.sublist(0, 9) : medias;
    final crossAxisCount = displayMedias.length == 1
        ? 1
        : (displayMedias.length == 2 || displayMedias.length == 4 ? 2 : 3);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: displayMedias.length,
      itemBuilder: (context, index) {
        final media = displayMedias[index];
        if (media.mediaType.startsWith('image')) {
          return GestureDetector(
            onTap: () {
              // 图片预览功能
              // TODO: 实现图片预览
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                media.mediaUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.white),
                  );
                },
              ),
            ),
          );
        } else if (media.mediaType.startsWith('video')) {
          // 视频缩略图
          return Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  media.mediaUrl, // 这里应该是视频缩略图URL
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child:
                          const Icon(Icons.broken_image, color: Colors.white),
                    );
                  },
                ),
              ),
              const Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 40,
              ),
            ],
          );
        } else {
          // 其他类型媒体
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.insert_drive_file, color: Colors.white),
          );
        }
      },
    );
  }
}
