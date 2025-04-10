import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_mobile/models/post_model.dart';
import 'package:im_mobile/utils/logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:im_mobile/providers/post_provider.dart';
import 'package:im_mobile/services/post_service.dart';
import 'package:im_mobile/utils/toast_util.dart';
import 'package:path/path.dart' as path;

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final TextEditingController _contentController = TextEditingController();
  final List<File> _selectedMedia = [];
  bool _isLoading = false;
  final int _maxMediaCount = 9; // 最大媒体文件数量

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  // 选择图片
  Future<void> _pickImages() async {
    if (_selectedMedia.length >= _maxMediaCount) {
      ToastUtil.show('最多只能上传$_maxMediaCount张图片');
      return;
    }

    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    
    if (images.isEmpty) return;

    // 计算还能选择多少张图片
    final int remainingSlots = _maxMediaCount - _selectedMedia.length;
    final List<XFile> selectedImages = images.length > remainingSlots 
        ? images.sublist(0, remainingSlots) 
        : images;

    setState(() {
      for (var image in selectedImages) {
        _selectedMedia.add(File(image.path));
      }
    });
  }

  // 选择视频
  Future<void> _pickVideo() async {
    if (_selectedMedia.length >= _maxMediaCount) {
      ToastUtil.show('最多只能上传$_maxMediaCount个媒体文件');
      return;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    
    if (video == null) return;

    setState(() {
      _selectedMedia.add(File(video.path));
    });
  }

  // 移除选中的媒体文件
  void _removeMedia(int index) {
    setState(() {
      _selectedMedia.removeAt(index);
    });
  }

  // 发布动态
  Future<void> _publishPost() async {
    final content = _contentController.text.trim();
    if (content.isEmpty && _selectedMedia.isEmpty) {
      ToastUtil.show('请输入内容或选择图片');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 上传图片获取URL列表
      List<MediaModel> mediaUrls = [];
      if (_selectedMedia.isNotEmpty) {

        mediaUrls = await PostService.upload(_selectedMedia);
      }

      // 调用创建动态API
      final result = await PostService.createPost(content, mediaUrls);
      
      if (result != null) {
        // 刷新动态列表
        await ref.read(timelinePostsProvider.notifier).refresh();
        
        if (!mounted) return;
        ToastUtil.show('发布成功');
        context.pop();
      } else {
        if (!mounted) return;
        ToastUtil.show('发布失败，请重试');
      }
    } catch (e,s) {
      Log.e("_publishPost", "发布失败",e,s);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发布动态'),
        actions: [
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : TextButton(
                  onPressed: _publishPost,
                  child: const Text(
                    '发布',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 内容输入区域
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _contentController,
                maxLines: 5,
                maxLength: 500,
                decoration: const InputDecoration(
                  hintText: '分享你的想法...',
                  border: InputBorder.none,
                ),
              ),
            ),
            
            // 已选媒体文件预览
            if (_selectedMedia.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildMediaPreview(),
              ),
            
            const Divider(),
            
            // 媒体选择按钮
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _buildMediaButton(
                    icon: Icons.image,
                    label: '图片',
                    onTap: _pickImages,
                  ),
                  const SizedBox(width: 16),
                  _buildMediaButton(
                    icon: Icons.videocam,
                    label: '视频',
                    onTap: _pickVideo,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建媒体选择按钮
  Widget _buildMediaButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  // 构建媒体文件预览网格
  Widget _buildMediaPreview() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _selectedMedia.length,
      itemBuilder: (context, index) {
        final file = _selectedMedia[index];
        final isVideo = path.extension(file.path).toLowerCase() == '.mp4';
        
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300],
              ),
              clipBehavior: Clip.antiAlias,
              child: isVideo
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.file(
                          file,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.videocam, size: 40),
                            );
                          },
                        ),
                        const Icon(
                          Icons.play_circle_outline,
                          size: 40,
                          color: Colors.white,
                        ),
                      ],
                    )
                  : Image.file(
                      file,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => _removeMedia(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}