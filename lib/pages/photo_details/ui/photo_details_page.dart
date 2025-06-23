import 'package:auto_route/auto_route.dart';
import 'package:berkut/helpers/app_fonts.dart';
import 'package:berkut/pages/favorite/ui/widgets/custom_app_bar.dart';
import 'package:berkut/providers/photo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../models/photo.dart';

@RoutePage()
class PhotoDetailsPage extends StatefulWidget {
  final Photo photo;

  const PhotoDetailsPage({super.key, required this.photo});

  @override
  State<PhotoDetailsPage> createState() => _PhotoDetailsPageState();
}

class _PhotoDetailsPageState extends State<PhotoDetailsPage> {
  late Future<Photo?> _photoDetailsFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _photoDetailsFuture = Provider.of<PhotoProvider>(context, listen: false)
          .getPhotoDetails(widget.photo.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(),
              Consumer<PhotoProvider>(
                builder: (context, provider, child) {
                  if (provider.state == PhotoLoadingState.loading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (provider.state == PhotoLoadingState.error) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          provider.error.isNotEmpty
                              ? provider.error
                              : 'Error loading photo details',
                          style:
                              AppFonts.regularBody.copyWith(color: Colors.red),
                        ),
                      ),
                    );
                  }

                  final detailedPhoto = provider.photos.firstWhere(
                    (p) => p.id == widget.photo.id,
                    orElse: () => widget.photo,
                  );

                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              if (detailedPhoto.user.profileImage != null)
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          detailedPhoto.user.profileImage ?? '',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    width: 48,
                                    height: 48),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      detailedPhoto.user.name,
                                      style: AppFonts.regularBody.copyWith(
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      '@${detailedPhoto.user.username}',
                                      style: AppFonts.regularBody.copyWith(
                                        color: Color(0xffBDBDBD),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Consumer<PhotoProvider>(
                                builder: (context, provider, child) {
                                  final isFavorite =
                                      provider.isFavorite(detailedPhoto.id);
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: isFavorite
                                          ? Colors.red.shade50
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: SvgPicture.asset(
                                        'assets/svgs/like.svg',
                                        width: 24,
                                        color: isFavorite
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                      onPressed: () {
                                        context
                                            .read<PhotoProvider>()
                                            .toggleFavorite(detailedPhoto);
                                      },
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: SvgPicture.asset(
                                      'assets/svgs/download.svg',
                                      width: 24,
                                      color: Colors.black),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                    detailedPhoto.urls['regular'] ?? '',
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    height: 230),
                              ),
                              Positioned(
                                right: 12,
                                bottom: 12,
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog.fullscreen(
                                        backgroundColor: Colors.black,
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Image.network(
                                                detailedPhoto.urls['regular'] ??
                                                    '',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            Positioned(
                                              top: 16,
                                              right: 16,
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 32,
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      // color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/svgs/maximize.svg',
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
