import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'booking_screen.dart';
import 'home_screen.dart';

const kPrimaryGreen = Color(0xFF2D6A4F);
const kBgGray = Color(0xFFF5F5F5);
const kInputBg = Color(0xFFEAEAEA);
const kHintColor = Color(0xFFAAAAAA);
const kTextColor = Color(0xFF1A1A1A);

class NearbyWisataItem {
  final WisataItem wisata;
  final double distanceMeter;

  NearbyWisataItem({
    required this.wisata,
    required this.distanceMeter,
  });

  String get distanceText {
    if (distanceMeter >= 1000) {
      return '${(distanceMeter / 1000).toStringAsFixed(1)} km';
    }

    return '${distanceMeter.toStringAsFixed(0)} m';
  }
}

class WisataTerdekatScreen extends StatelessWidget {
  final List<NearbyWisataItem> items;

  const WisataTerdekatScreen({
    super.key,
    required this.items,
  });

  Future<void> _openRoute(BuildContext context, WisataItem item) async {
    if (item.latitude == null || item.longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Koordinat wisata belum tersedia.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${item.latitude},${item.longitude}&travelmode=driving',
    );

    final success = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak bisa membuka Google Maps.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _openBooking(BuildContext context, WisataItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingScreen(
          idWisata: item.idWisata,
          namaWisata: item.name,
          lokasi: item.location,
          kategori: item.category,
          harga: item.price,
          imageUrl: item.imageUrl,
          latitude: item.latitude,
          longitude: item.longitude,
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  Widget _imageFallback() {
    return Container(
      width: 92,
      height: 92,
      color: kInputBg,
      child: const Icon(
        Icons.image,
        color: kHintColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nearestItems = items.take(10).toList();

    return Scaffold(
      backgroundColor: kBgGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: kTextColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Wisata Terdekat',
          style: TextStyle(
            color: kPrimaryGreen,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: nearestItems.isEmpty
          ? const Center(
              child: Text(
                'Belum ada data wisata terdekat.',
                style: TextStyle(
                  color: kHintColor,
                  fontSize: 14,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Destinasi Terdekat Kamu',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: kTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Diurutkan berdasarkan jarak dari lokasi kamu saat ini.',
                  style: TextStyle(
                    fontSize: 13,
                    color: kHintColor,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                ...nearestItems.map(
                  (nearby) => _NearbyCard(
                    nearby: nearby,
                    formatPrice: _formatPrice,
                    onBooking: () => _openBooking(context, nearby.wisata),
                    onRoute: () => _openRoute(context, nearby.wisata),
                    imageFallback: _imageFallback,
                  ),
                ),
              ],
            ),
    );
  }
}

class _NearbyCard extends StatelessWidget {
  final NearbyWisataItem nearby;
  final String Function(int) formatPrice;
  final VoidCallback onBooking;
  final VoidCallback onRoute;
  final Widget Function() imageFallback;

  const _NearbyCard({
    required this.nearby,
    required this.formatPrice,
    required this.onBooking,
    required this.onRoute,
    required this.imageFallback,
  });

  @override
  Widget build(BuildContext context) {
    final item = nearby.wisata;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: item.imageUrl.isEmpty
                ? imageFallback()
                : Image.network(
                    item.imageUrl,
                    width: 92,
                    height: 92,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => imageFallback(),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: kTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.near_me_outlined,
                      size: 14,
                      color: kPrimaryGreen,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      nearby.distanceText,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.location,
                  style: const TextStyle(
                    fontSize: 11,
                    color: kHintColor,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  item.price == 0 ? 'Gratis' : 'Rp ${formatPrice(item.price)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: kTextColor,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: onBooking,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryGreen,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text(
                            'Pesan',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 42,
                      height: 36,
                      child: OutlinedButton(
                        onPressed: onRoute,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side: const BorderSide(color: kPrimaryGreen),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Icon(
                          Icons.map_outlined,
                          size: 18,
                          color: kPrimaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}