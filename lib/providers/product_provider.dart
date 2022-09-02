import 'dart:convert' as convert;

import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Product copyWith({
    String id,
    String title,
    String description,
    double price,
    String imageUrl,
    bool isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  var _toggleFavoriteIsLoading = false;

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    if (!_toggleFavoriteIsLoading) {
      _toggleFavoriteIsLoading = true;
      final currentIsFavorite = isFavorite;
      isFavorite = !isFavorite;
      notifyListeners();

      final url = Uri.parse(
          'https://udemy-flutter-shop-5c552-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');
      try {
        final response = await http.put(
          url,
          body: convert.jsonEncode(
            isFavorite,
          ),
        );
        if (response.statusCode >= 400) {
          isFavorite = currentIsFavorite;
          notifyListeners();
          throw HttpException('Could not favorite product.');
        }
      } catch (e) {
        isFavorite = currentIsFavorite;
        notifyListeners();
        rethrow;
      } finally {
        _toggleFavoriteIsLoading = false;
      }
    } else {
      return;
    }
  }
}
