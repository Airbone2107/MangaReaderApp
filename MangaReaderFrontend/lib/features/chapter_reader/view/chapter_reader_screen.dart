import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../data/models/chapter_model.dart';
import '../../../data/services/user_api_service.dart';
import '../logic/chapter_reader_logic.dart';

/// Màn hình đọc chapter, hiển thị danh sách ảnh và các điều khiển.
class ChapterReaderScreen extends StatefulWidget {
  final Chapter chapter;
  const ChapterReaderScreen({super.key, required this.chapter});

  @override
  State<ChapterReaderScreen> createState() => _ChapterReaderScreenState();
}

class _ChapterReaderScreenState extends State<ChapterReaderScreen> {
  late ChapterReaderLogic _logic;
  late Future<List<String>> _chapterPages;
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  bool _isFollowing = false;
  // Kéo quá rìa để chuyển chương (áp dụng cho đọc dọc)
  double _footerRevealPx = 0.0;
  double _topOverscroll = 0.0;
  bool _readyNext = false;
  bool _readyPrev = false;
  bool _isNavigating = false;
  final double _footerFriction = 0.6;

  @override
  void initState() {
    super.initState();
    _logic = ChapterReaderLogic(
      userService: UserApiService(),
      setState: (VoidCallback fn) {
        if (mounted) {
          setState(fn);
        }
      },
      scrollController: _scrollController,
    );

    _logic.updateProgress(widget.chapter);
    _chapterPages = _logic.fetchChapterPages(widget.chapter.chapterId);
    _checkFollowingStatus();
  }

  Future<void> _checkFollowingStatus() async {
    final bool followingStatus = await _logic.isFollowingManga(
      widget.chapter.mangaId,
    );
    if (mounted) {
      setState(() {
        _isFollowing = followingStatus;
      });
    }
  }

  @override
  void dispose() {
    _logic.dispose();
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () =>
            setState(() => _logic.areBarsVisible = !_logic.areBarsVisible),
        child: Stack(
          children: <Widget>[
            FutureBuilder<List<String>>(
              future: _chapterPages,
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Lỗi:  ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Không có trang nào.'));
                    }
                    final List<String> urls = snapshot.data!;
                    return _logic.readingMode == ReadingMode.vertical
                        ? _buildVerticalReader(urls)
                        : _buildHorizontalReader(urls);
                  },
            ),
            if (_logic.areBarsVisible) _buildOverlay(context),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalReader(List<String> urls) {
    final Size size = MediaQuery.of(context).size;
    final double threshold = size.height / 6; // ngưỡng 1/6 màn hình
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        // Reset tích luỹ khi bắt đầu một cử chỉ cuộn mới
        if (notification is ScrollStartNotification) {
          setState(() {
            _footerRevealPx = 0.0;
            _topOverscroll = 0.0;
            _readyNext = false;
            _readyPrev = false;
          });
        }

        // Tích luỹ overscroll khi ở rìa danh sách
        if (notification is OverscrollNotification) {
          final ScrollMetrics metrics = notification.metrics;
          final double delta = notification.overscroll;
          if (metrics.pixels >= metrics.maxScrollExtent && delta > 0) {
            // Đang kéo quá đáy
            setState(() {
              _footerRevealPx = (_footerRevealPx + delta * _footerFriction)
                  .clamp(0.0, threshold);
              _readyNext = _footerRevealPx >= threshold;
            });
          }
          if (metrics.pixels <= metrics.minScrollExtent && delta < 0) {
            // Đang kéo quá đỉnh
            setState(() {
              _topOverscroll += -delta;
              if (_topOverscroll >= threshold) {
                _readyPrev = true;
              }
            });
          }
        }

        // Khi người dùng thả tay, cuộn dừng hẳn -> kích hoạt chuyển chương nếu đủ ngưỡng
        if (!_isNavigating && notification is ScrollEndNotification) {
          final int currentIndex = _logic.getCurrentIndex(widget.chapter);
          if (_readyNext) {
            _isNavigating = true;
            _logic.goToNextChapter(context, widget.chapter, currentIndex);
          } else if (_readyPrev) {
            _isNavigating = true;
            _logic.goToPreviousChapter(context, widget.chapter, currentIndex);
          } else {
            // Không đạt ngưỡng, thu trang thông báo lại
            setState(() {
              _footerRevealPx = 0.0;
              _topOverscroll = 0.0;
            });
          }
        }

        return false;
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: urls.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index < urls.length) {
            final bool isHeightConstrained =
                _logic.scaleMode == ImageScaleMode.fitHeight;
            final Widget image = _buildPlainImage(
              url: urls[index],
              width: size.width,
              height: isHeightConstrained ? size.height : null,
            );
            if (isHeightConstrained) {
              return SizedBox(
                height: size.height,
                width: size.width,
                child: image,
              );
            }
            return image;
          }
          // Footer "trang thông báo" dính ở đáy
          final double progress = (_footerRevealPx / threshold).clamp(0.0, 1.0);
          final String text = progress >= 1.0
              ? 'Thả để chuyển chương'
              : 'Kéo lên để chuyển chương';
          return AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            height: _footerRevealPx,
            width: size.width,
            color: Colors.black.withOpacity(0.15 + 0.25 * progress),
            child: _footerRevealPx <= 0
                ? const SizedBox.shrink()
                : Center(
                    child: Opacity(
                      opacity: 0.6 + 0.4 * progress,
                      child: Transform.scale(
                        scale: 1.0 + 0.06 * progress,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Icon(
                              Icons.keyboard_double_arrow_up,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalReader(List<String> urls) {
    final Size size = MediaQuery.of(context).size;
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      itemCount: urls.length,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          width: size.width,
          height: size.height,
          child: _buildZoomableImage(
            url: urls[index],
            width: size.width,
            height: size.height,
          ),
        );
      },
    );
  }

  Widget _buildZoomableImage({
    required String url,
    double? width,
    double? height,
  }) {
    final BoxFit fit;
    switch (_logic.scaleMode) {
      case ImageScaleMode.fitWidth:
        fit = BoxFit.fitWidth;
        break;
      case ImageScaleMode.fitHeight:
        fit = BoxFit.fitHeight;
        break;
    }

    final Widget img = CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: width,
      height: height,
      placeholder: (BuildContext context, String url) => const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (
        BuildContext context,
        String url,
        Object error,
      ) => const SizedBox(
        height: 300,
        child: Center(child: Icon(Icons.error)),
      ),
    );

    return InteractiveViewer(
      clipBehavior: Clip.none,
      panEnabled: true,
      scaleEnabled: true,
      minScale: 1.0,
      maxScale: 4.0,
      child: img,
    );
  }

  Widget _buildPlainImage({
    required String url,
    double? width,
    double? height,
  }) {
    final BoxFit fit;
    switch (_logic.scaleMode) {
      case ImageScaleMode.fitWidth:
        fit = BoxFit.fitWidth;
        break;
      case ImageScaleMode.fitHeight:
        fit = BoxFit.fitHeight;
        break;
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: width,
      height: height,
      placeholder: (BuildContext context, String url) => const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (
        BuildContext context,
        String url,
        Object error,
      ) => const SizedBox(
        height: 300,
        child: Center(child: Icon(Icons.error)),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final int currentIndex = _logic.getCurrentIndex(widget.chapter);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildAppBar(context),
        _buildBottomNavBar(context, currentIndex),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: Colors.black54,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Center(
              child: Text(
                widget.chapter.chapterName,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: 48), // To balance the back button
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
    return Container(
      color: Colors.black54,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => _logic.goToPreviousChapter(
              context,
              widget.chapter,
              currentIndex,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: _openSettings,
          ),
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (Route<dynamic> route) => false,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.bookmark,
              color: _isFollowing ? Colors.green : Colors.white,
            ),
            onPressed: () async {
              if (_isFollowing) {
                await _logic.removeFromFollowing(
                  context,
                  widget.chapter.mangaId,
                );
              } else {
                await _logic.followManga(context, widget.chapter.mangaId);
              }
              _checkFollowingStatus();
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () =>
                _logic.goToNextChapter(context, widget.chapter, currentIndex),
          ),
        ],
      ),
    );
  }

  void _openSettings() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.grey[900],
      showDragHandle: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Text(
                    'Chế độ đọc',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                RadioListTile<ReadingMode>(
                  value: ReadingMode.vertical,
                  groupValue: _logic.readingMode,
                  onChanged: (ReadingMode? v) {
                    if (v == null) return;
                    setState(() => _logic.readingMode = v);
                    Navigator.of(context).maybePop();
                  },
                  activeColor: Colors.white,
                  title: const Text('Đọc dọc', style: TextStyle(color: Colors.white)),
                ),
                RadioListTile<ReadingMode>(
                  value: ReadingMode.horizontal,
                  groupValue: _logic.readingMode,
                  onChanged: (ReadingMode? v) {
                    if (v == null) return;
                    setState(() => _logic.readingMode = v);
                    Navigator.of(context).maybePop();
                  },
                  activeColor: Colors.white,
                  title: const Text('Đọc ngang', style: TextStyle(color: Colors.white)),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text(
                    'Scale ảnh',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                RadioListTile<ImageScaleMode>(
                  value: ImageScaleMode.fitWidth,
                  groupValue: _logic.scaleMode,
                  onChanged: (ImageScaleMode? v) {
                    if (v == null) return;
                    setState(() => _logic.scaleMode = v);
                  },
                  activeColor: Colors.white,
                  title: const Text('Vừa theo bề ngang màn hình',
                      style: TextStyle(color: Colors.white)),
                ),
                RadioListTile<ImageScaleMode>(
                  value: ImageScaleMode.fitHeight,
                  groupValue: _logic.scaleMode,
                  onChanged: (ImageScaleMode? v) {
                    if (v == null) return;
                    setState(() => _logic.scaleMode = v);
                  },
                  activeColor: Colors.white,
                  title: const Text('Vừa theo chiều dọc màn hình',
                      style: TextStyle(color: Colors.white)),
                ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}


