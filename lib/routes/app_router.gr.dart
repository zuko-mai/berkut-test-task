// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    FavoriteRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const FavoritePage(),
      );
    },
    PhotoDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<PhotoDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PhotoDetailsPage(
          key: args.key,
          photo: args.photo,
        ),
      );
    },
    SearchRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SearchPage(),
      );
    },
  };
}

/// generated route for
/// [FavoritePage]
class FavoriteRoute extends PageRouteInfo<void> {
  const FavoriteRoute({List<PageRouteInfo>? children})
      : super(
          FavoriteRoute.name,
          initialChildren: children,
        );

  static const String name = 'FavoriteRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PhotoDetailsPage]
class PhotoDetailsRoute extends PageRouteInfo<PhotoDetailsRouteArgs> {
  PhotoDetailsRoute({
    Key? key,
    required Photo photo,
    List<PageRouteInfo>? children,
  }) : super(
          PhotoDetailsRoute.name,
          args: PhotoDetailsRouteArgs(
            key: key,
            photo: photo,
          ),
          initialChildren: children,
        );

  static const String name = 'PhotoDetailsRoute';

  static const PageInfo<PhotoDetailsRouteArgs> page =
      PageInfo<PhotoDetailsRouteArgs>(name);
}

class PhotoDetailsRouteArgs {
  const PhotoDetailsRouteArgs({
    this.key,
    required this.photo,
  });

  final Key? key;

  final Photo photo;

  @override
  String toString() {
    return 'PhotoDetailsRouteArgs{key: $key, photo: $photo}';
  }
}

/// generated route for
/// [SearchPage]
class SearchRoute extends PageRouteInfo<void> {
  const SearchRoute({List<PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
