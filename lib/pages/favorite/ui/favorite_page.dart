import 'package:auto_route/auto_route.dart';
import 'package:berkut/helpers/app_fonts.dart';
import 'package:berkut/pages/favorite/ui/widgets/custom_app_bar.dart';
import 'package:berkut/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/photo_provider.dart';
import '../../../models/photo.dart';

@RoutePage()
class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
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
        child: ClipRRect(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppBar(
                hideIcon: 2,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Text('Избранное', style: AppFonts.boldH1)),
              Consumer<PhotoProvider>(
                builder: (context, photoProvider, child) {
                  if (photoProvider.favorites.isEmpty) {
                    return SizedBox();
                  }

                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 16, bottom: 24),
                    itemCount: photoProvider.favorites.length,
                    itemBuilder: (context, index) {
                      return _buildPhotoItem(photoProvider.favorites[index]);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
