import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// WISHLIST STORE
// ─────────────────────────────────────────────

class WishlistItem {
  final String id;
  final String name;
  final String imageUrl;

  const WishlistItem({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

class WishlistStore extends ValueNotifier<List<WishlistItem>> {
  WishlistStore() : super([]);

  bool isWishlisted(String id) => value.any((item) => item.id == id);

  void toggle(WishlistItem item) {
    if (isWishlisted(item.id)) {
      value = value.where((e) => e.id != item.id).toList();
    } else {
      value = [...value, item];
    }
  }
}

// Singleton global
final wishlistStore = WishlistStore();
