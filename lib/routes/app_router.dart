import 'package:auto_route/auto_route.dart';
import 'package:berkut/models/photo.dart';
import 'package:berkut/pages/favorite/ui/favorite_page.dart';
import 'package:berkut/pages/photo_details/ui/photo_details_page.dart';
import 'package:berkut/pages/search/ui/search_page.dart';
import 'package:flutter/material.dart';
part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          page: SearchRoute.page,
        ),
        AutoRoute(
          // initial: true,
          page: FavoriteRoute.page,
        ),
        AutoRoute(
          page: PhotoDetailsRoute.page,
        ),
      ];
}
