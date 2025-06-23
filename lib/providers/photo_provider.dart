import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/photo.dart';
import '../services/unsplash_service.dart';

enum PhotoLoadingState { initial, loading, loaded, error }

class PhotoProvider extends ChangeNotifier {
  final UnsplashService _unsplashService = UnsplashService();
  static const String _favoritesKey = 'favorites';
  late SharedPreferences _prefs;

  List<Photo> _photos = [];
  List<Photo> get photos => _photos;

  List<Photo> _searchResults = [];
  List<Photo> get searchResults => _searchResults;

  List<Photo> _favorites = [];
  List<Photo> get favorites => _favorites;

  String _error = '';
  String get error => _error;

  PhotoLoadingState _state = PhotoLoadingState.initial;
  PhotoLoadingState get state => _state;

  PhotoProvider() {
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favoritesJson = _prefs.getStringList(_favoritesKey) ?? [];
    _favorites = favoritesJson
        .map((jsonStr) => Photo.fromJson(json.decode(jsonStr)))
        .toList();
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final favoritesJson =
        _favorites.map((photo) => json.encode(photo.toJson())).toList();
    await _prefs.setStringList(_favoritesKey, favoritesJson);
  }

  int _currentPage = 1;
  String _currentQuery = '';
  DateTime? _lastSearchTime;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  // Load random photos for the main page
  Future<void> loadRandomPhotos() async {
    try {
      _state = PhotoLoadingState.loading;
      notifyListeners();

      _photos = await _unsplashService.getRandomPhotos();

      // Update isFavorite status for loaded photos
      _photos = _photos.map((photo) {
        return photo.copyWith(
          isFavorite: _favorites.any((f) => f.id == photo.id),
        );
      }).toList();

      _state = PhotoLoadingState.loaded;
    } catch (e) {
      _error = e.toString();
      _state = PhotoLoadingState.error;
    } finally {
      notifyListeners();
    }
  }

  // Search photos
  Future<void> searchPhotos(String query, {bool reset = false}) async {
    if (query.isEmpty) return;

    // If it's a new search or reset is requested
    if (_currentQuery != query || reset) {
      _currentQuery = query;
      _currentPage = 1;
      _hasMore = true;
      _searchResults = [];
    }

    // Check if we can load more
    if (!_hasMore) return;

    // Throttle check - only apply throttle for new searches, not pagination
    if (_currentPage == 1 && _lastSearchTime != null) {
      final timeDiff = DateTime.now().difference(_lastSearchTime!);
      if (timeDiff.inSeconds < 3) return;
    }

    try {
      _state = _searchResults.isEmpty
          ? PhotoLoadingState.loading
          : PhotoLoadingState
              .loaded; // Don't show full screen loader when loading more
      notifyListeners();

      final searchResult = await _unsplashService.searchPhotos(
        query,
        page: _currentPage,
      );

      final results = searchResult.results.map((photo) {
        return photo.copyWith(
          isFavorite: _favorites.any((f) => f.id == photo.id),
        );
      }).toList();

      if (_currentPage == 1) {
        _searchResults = results;
      } else {
        _searchResults.addAll(results);
      }

      _hasMore = _currentPage < searchResult.totalPages;
      _currentPage++;
      _lastSearchTime = DateTime.now();
      _state = PhotoLoadingState.loaded;
    } catch (e) {
      _error = e.toString();
      _state = PhotoLoadingState.error;
    } finally {
      notifyListeners();
    }
  }

  // Get photo details
  Future<Photo?> getPhotoDetails(String id) async {
    _state = PhotoLoadingState.loading;
    notifyListeners();

    try {
      final photo = await _unsplashService.getPhotoDetails(id);
      if (photo != null) {
        final updatedPhoto = photo.copyWith(
          isFavorite: _favorites.any((f) => f.id == photo.id),
        );

        // Update photo in main photos list if it exists there
        final photoIndex = _photos.indexWhere((p) => p.id == photo.id);
        if (photoIndex != -1) {
          _photos[photoIndex] = updatedPhoto;
        } else {
          _photos.add(updatedPhoto);
        }
      }

      _state = PhotoLoadingState.loaded;
      notifyListeners();
      return photo;
    } catch (e) {
      _error = e.toString();
      _state = PhotoLoadingState.error;
      notifyListeners();
      return null;
    }
  }

  // Favorites management
  Future<void> toggleFavorite(Photo photo) async {
    final isAlreadyFavorite = _favorites.any((p) => p.id == photo.id);
    final updatedPhoto = photo.copyWith(isFavorite: !isAlreadyFavorite);

    if (isAlreadyFavorite) {
      _favorites.removeWhere((p) => p.id == photo.id);
    } else {
      _favorites.add(updatedPhoto);
    }

    // Update photo in search results if it exists there
    final searchIndex = _searchResults.indexWhere((p) => p.id == photo.id);
    if (searchIndex != -1) {
      _searchResults[searchIndex] = updatedPhoto;
    }

    // Update photo in main photos list if it exists there
    final photoIndex = _photos.indexWhere((p) => p.id == photo.id);
    if (photoIndex != -1) {
      _photos[photoIndex] = updatedPhoto;
    }

    await _saveFavorites();
    notifyListeners();
  }

  bool isFavorite(String photoId) {
    return _favorites.any((photo) => photo.id == photoId);
  }

  // Clear search results
  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

  // Reset error state
  void clearError() {
    _error = '';
    _state = PhotoLoadingState.initial;
    notifyListeners();
  }
}
