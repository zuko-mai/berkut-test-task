import 'package:auto_route/auto_route.dart';
import 'package:berkut/pages/favorite/ui/widgets/custom_app_bar.dart';
import 'package:berkut/pages/search/ui/widgets/text_field.dart';
import 'package:berkut/routes/app_router.dart';
import 'package:berkut/providers/photo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/photo.dart';

@RoutePage()
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController _scrollController = ScrollController();
  String _currentQuery = '';
  bool _isLoadingMore = false;
  DateTime? _lastScrollTime;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load random photos when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PhotoProvider>().loadRandomPhotos();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_currentQuery.isEmpty) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = maxScroll * 0.8;

    if (currentScroll >= threshold) {
      final provider = context.read<PhotoProvider>();
      if (!_isLoadingMore &&
          provider.state != PhotoLoadingState.loading &&
          provider.hasMore) {
        _isLoadingMore = true;
        provider.searchPhotos(_currentQuery).then((_) {
          if (mounted) {
            setState(() {
              _isLoadingMore = false;
            });
          }
        });
      }
    }
  }

  Widget _buildPhotoItem(Photo photo) {
    return GestureDetector(
        onTap: () => context.router.replace(PhotoDetailsRoute(photo: photo)),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  photo.urls['regular'] ?? '',
                  width: double.infinity,
                  height: 320,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 320,
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)
            .unfocus(); // Dismiss the keyboard when tapping outside
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomAppBar(hideIcon: 1),
                Container(
                  height: 230,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: TextFieldWidget(
                    onSearch: (query) {
                      setState(() {
                        _currentQuery = query;
                      });
                      if (mounted) {
                        context
                            .read<PhotoProvider>()
                            .searchPhotos(query, reset: true);
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height -
                      330, // Subtract header height
                  child: Consumer<PhotoProvider>(
                    builder: (context, provider, child) {
                      if (provider.state == PhotoLoadingState.loading &&
                          provider.searchResults.isEmpty) {
                        return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ));
                      }

                      if (provider.state == PhotoLoadingState.error) {
                        return Center(
                          child: Text(
                            provider.error,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      // Show random photos if no search query
                      final displayPhotos = _currentQuery.isEmpty
                          ? provider.photos
                          : provider.searchResults;

                      if (displayPhotos.isEmpty) {
                        return const Center(
                          child: Text(
                            'No photos found',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(top: 16, bottom: 24),
                        itemCount: displayPhotos.length + 1,
                        itemBuilder: (context, index) {
                          if (index == displayPhotos.length) {
                            return (_currentQuery.isNotEmpty &&
                                    provider.hasMore)
                                ? const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          }
                          return _buildPhotoItem(displayPhotos[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
