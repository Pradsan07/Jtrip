import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// WARNA & KONSTANTA
// ─────────────────────────────────────────────
const kPrimaryGreen = Color(0xFF2D6A4F);
const kBgGray = Color(0xFFF5F5F5);
const kInputBg = Color(0xFFEAEAEA);
const kLabelColor = Color(0xFF333333);
const kHintColor = Color(0xFFAAAAAA);
const kTextColor = Color(0xFF1A1A1A);

// ─────────────────────────────────────────────
// MODEL DATA
// ─────────────────────────────────────────────
class PromoItem {
  final String title;
  final String badge;
  final String subtitle;
  final String imageUrl;
  PromoItem({
    required this.title,
    required this.badge,
    required this.subtitle,
    required this.imageUrl,
  });
}

class PopularItem {
  final String title;
  final String location;
  final String description;
  final String price;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final bool isFeatured;
  PopularItem({
    required this.title,
    required this.location,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    this.isFeatured = false,
  });
}

// ─────────────────────────────────────────────
// DUMMY DATA
// ─────────────────────────────────────────────
final List<PromoItem> promoList = [
  PromoItem(
    title: 'Eksplorasi Papuma',
    badge: 'Promo Khusus',
    subtitle: 'Diskon 30% Tiket Masuk',
    imageUrl:
        'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/ae/32/83/monggo-indonesia-one.jpg?w=1200&h=-1&s=1',
  ),
  PromoItem(
    title: 'Wisata Rembangan',
    badge: 'Promo Khusus',
    subtitle: 'Diskon 30%',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSbpjTwSVMkFjoGVbddSfmCu2HLzPqaY-3_8g&s',
  ),
  PromoItem(
    title: 'Kebun Teh Gambir',
    badge: 'Promo Khusus',
    subtitle: 'Diskon 30%',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWZiKgwwQt5RoN1cvSC9sVFnsAxVN3c587Zw&s',
  ),
];

final List<PopularItem> popularList = [
  PopularItem(
    title: 'Kebun Teh',
    location: 'Jember',
    description: 'Nikmati udara sejuk dan panorama hijau ..',
    price: 'Rp 15.000',
    rating: 4.9,
    reviewCount: 1200,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSu0REjuO5OJOvqluw7VHzyORx5-S2nBPPqNg&s',
    isFeatured: true,
  ),
  PopularItem(
    title: 'Air Terjun Tancak',
    location: 'Pati, Jember',
    description: '',
    price: 'Rp 10.000',
    rating: 4.7,
    reviewCount: 890,
    imageUrl:
        'https://images.unsplash.com/photo-1431794062232-2a99a5431c6c?w=400',
  ),
  PopularItem(
    title: 'Air Terjun Tancak',
    location: 'Pati, Jember',
    description: '',
    price: 'Rp 10.000',
    rating: 4.7,
    reviewCount: 890,
    imageUrl:
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
  ),
];

// ─────────────────────────────────────────────
// HOME SCREEN
// ─────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGray,
      appBar: _buildAppBar(),
      body: _currentIndex == 0 ? _buildBody() : _buildPlaceholder(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── APP BAR ──
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: kTextColor),
        onPressed: () {},
      ),
      title: const Text(
        'Jelajahi Jember',
        style: TextStyle(
          color: kPrimaryGreen,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () {},
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=47'),
            ),
          ),
        ),
      ],
    );
  }

  // ── BODY ──
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          _buildHeader(),
          _buildSearchBar(),
          const SizedBox(height: 20),
          _buildCategories(),
          const SizedBox(height: 20),
          _buildPromoSection(),
          const SizedBox(height: 24),
          _buildPopularHeader(),
          const SizedBox(height: 12),
          _buildFeaturedCard(),
          const SizedBox(height: 12),
          _buildGridCards(),
          const SizedBox(height: 16),
          _buildNearbyBanner(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── HEADER ──
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Halo, Sobat Jember',
            style: TextStyle(fontSize: 13, color: kHintColor),
          ),
          SizedBox(height: 4),
          Text(
            'Mau kemana hari ini?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: kTextColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── SEARCH BAR ──
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: kInputBg,
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Row(
          children: [
            SizedBox(width: 16),
            Icon(Icons.search, color: kHintColor, size: 20),
            SizedBox(width: 10),
            Text(
              'Cari destinasi atau kuliner...',
              style: TextStyle(color: kHintColor, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // ── KATEGORI ──
  final List<Map<String, dynamic>> _categories = [
    {
      'icon': Icons.confirmation_number_outlined,
      'label': 'Tiket Wisata',
      'color': Color(0xFF6ECFB0),
    },
    {
      'icon': Icons.restaurant_menu,
      'label': 'Kuliner\nSekitar',
      'color': Color(0xFFF5D59E),
    },
    {
      'icon': Icons.shopping_bag_outlined,
      'label': 'Pesanan',
      'color': Color(0xFFF5B87A),
    },
    {'icon': Icons.history, 'label': 'Riwayat', 'color': Color(0xFFE0E0E0)},
  ];

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _categories.map((cat) {
          return _CategoryItem(
            icon: cat['icon'] as IconData,
            label: cat['label'] as String,
            color: cat['color'] as Color,
          );
        }).toList(),
      ),
    );
  }

  // ── PROMO ──
  Widget _buildPromoSection() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: promoList.length,
        itemBuilder: (context, index) {
          final promo = promoList[index];
          return _PromoCard(promo: promo);
        },
      ),
    );
  }

  // ── POPULAR HEADER ──
  Widget _buildPopularHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Pilihan Populer',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: kTextColor,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'Lihat Semua',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kPrimaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── FEATURED CARD ──
  Widget _buildFeaturedCard() {
    final item = popularList[0];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.network(
                item.imageUrl,
                width: 130,
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 130,
                  color: kInputBg,
                  child: const Icon(Icons.image, color: kHintColor),
                ),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${item.rating}(${_formatCount(item.reviewCount)})',
                          style: const TextStyle(
                            fontSize: 12,
                            color: kHintColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: kTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(fontSize: 12, color: kHintColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.price,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── GRID CARDS ──
  Widget _buildGridCards() {
    final items = popularList.skip(1).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: items.map((item) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: items.indexOf(item) == 0 ? 8 : 0),
              child: _SmallCard(item: item),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── NEARBY BANNER ──
  Widget _buildNearbyBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Wisata Terdekat Kamu',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryGreen,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Temukan 5 destinasi menarik di sekitarmu',
                    style: TextStyle(fontSize: 12, color: kHintColor),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: kHintColor),
          ],
        ),
      ),
    );
  }

  // ── BOTTOM NAV ──
  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.explore_outlined, 'label': 'Wisata'},
      {'icon': Icons.confirmation_number_outlined, 'label': 'Pesan'},
      {'icon': Icons.restaurant_menu_outlined, 'label': 'Kuliner'},
      {'icon': Icons.person_outline, 'label': 'Profil'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isActive = _currentIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _currentIndex = index),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isActive
                            ? kPrimaryGreen.withOpacity(0.15)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        items[index]['icon'] as IconData,
                        color: isActive ? kPrimaryGreen : kHintColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      items[index]['label'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isActive ? kPrimaryGreen : kHintColor,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Text(
        'Halaman ini belum tersedia',
        style: TextStyle(color: kHintColor),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}

// ─────────────────────────────────────────────
// REUSABLE WIDGETS
// ─────────────────────────────────────────────

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: kTextColor,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  final PromoItem promo;

  const _PromoCard({required this.promo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              promo.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: kInputBg),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 14,
              left: 14,
              right: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      promo.badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    promo.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    promo.subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallCard extends StatelessWidget {
  final PopularItem item;

  const _SmallCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.network(
              item.imageUrl,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 110,
                color: kInputBg,
                child: const Icon(Icons.image, color: kHintColor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: kHintColor),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        item.location,
                        style: const TextStyle(fontSize: 11, color: kHintColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
