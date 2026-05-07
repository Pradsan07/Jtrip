import 'package:flutter/material.dart';
import 'booking_screen.dart';
import 'other_screens.dart';

const kPrimaryGreen = Color(0xFF2D6A4F);
const kBgGray = Color(0xFFF5F5F5);
const kInputBg = Color(0xFFEAEAEA);
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
  PopularItem({
    required this.title,
    required this.location,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
  });
}

class WisataItem {
  final String name;
  final String location;
  final String category;
  final int price;
  final String imageUrl;

  WisataItem({
    required this.name,
    required this.location,
    required this.category,
    required this.price,
    required this.imageUrl,
  });
}

final List<PromoItem> promoList = [
  PromoItem(
    title: 'Eksplorasi Papuma',
    badge: 'Promo Khusus',
    subtitle: 'Diskon 30% Tiket Masuk',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6tpfKpBNtbvDm8XCGOr_bqdaTp_Kr1hfPfA&s',
  ),
  PromoItem(
    title: 'Jember Mini Zoo',
    badge: 'Promo Khusus',
    subtitle: 'Diskon 10%',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiY_FEGG8uMS-c5t8tzB4xYyAWdmmI5YzZyQ&s',
  ),
];

//PILIHAN POPULER
final List<PopularItem> popularList = [
  PopularItem(
    title: 'Kebun Teh',
    location: 'Jember',
    description: 'Nikmati udara sejuk dan panorama hijau ..',
    price: 'Rp 15.000',
    rating: 4.9,
    reviewCount: 1200,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWZiKgwwQt5RoN1cvSC9sVFnsAxVN3c587Zw&s',
  ),
  PopularItem(
    title: 'Air Terjun Tancak',
    location: 'Panti, Jember',
    description: 'Air terjun indah',
    price: 'Rp 10.000',
    rating: 4.7,
    reviewCount: 890,
    imageUrl:
        'https://asset.kompas.com/crops/u6lHbbpGunVegubUBBnbKOricj4=/0x0:1000x667/1200x800/data/photo/2023/07/10/64ac00cec047a.jpg',
  ),
  PopularItem(
    title: 'Puncak Rembangan',
    location: 'Arjasa, Jember',
    description: '',
    price: 'Rp 10.000',
    rating: 4.7,
    reviewCount: 890,
    imageUrl:
        'https://static.promediateknologi.id/crop/0x0:0x0/1200x800/webp/photo/p1/51/2023/12/12/Screenshot_20231212-031540_Instagram-490263197.jpg',
  ),
  PopularItem(
    title: 'Teluk Love',
    location: 'Ambulu, Jember',
    description: '',
    price: 'Rp 10.000',
    rating: 4.7,
    reviewCount: 890,
    imageUrl:
        'https://chanelmuslim.com/wp-content/uploads/2021/07/210941255_141544724739389_481622034315275943_n-700x375.jpg',
  ),
];

final List<WisataItem> wisataList = [
  WisataItem(
    name: 'Pantai Papuma',
    location: 'Desa Lojejer, Kecamatan Wuluhan, Jember',
    category: 'Pantai',
    price: 25000,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6tpfKpBNtbvDm8XCGOr_bqdaTp_Kr1hfPfA&s',
  ),
  WisataItem(
    name: 'Watu Ulo',
    location: 'Desa Lojejer, Kecamatan Wuluhan, Jember',
    category: 'Pantai',
    price: 25000,
    imageUrl:
        'https://www.pantura7.com/wp-content/uploads/2025/10/IMG-20251015-WA0012-scaled.jpg',
  ),
  WisataItem(
    name: 'Puncak Rembangan',
    location: 'Kecamatan Arjasa, Jember',
    category: 'Pegunungan',
    price: 15000,
    imageUrl:
        'https://sidita.disbudpar.jatimprov.go.id/storage/foto-dtw/1a24d_1705981486.jpg',
  ),
  WisataItem(
    name: 'Air Terjun Tancak',
    location: 'Desa Kemiri, Panti, Jember',
    category: 'Pegunungan',
    price: 10000,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9gGaB6kC0-I7NVk4_-Slys4YsenlLabutbw&s',
  ),
  WisataItem(
    name: 'Kebun Teh Gunung Gambir',
    location: 'Kecamatan Silo, Jember',
    category: 'Pegunungan',
    price: 15000,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSu0REjuO5OJOvqluw7VHzyORx5-S2nBPPqNg&s',
  ),
  WisataItem(
    name: 'Pantai Bandealit',
    location: 'Taman Nasional Meru Betiri, Jember',
    category: 'Pantai',
    price: 20000,
    imageUrl:
        'https://assets.promediateknologi.id/crop/0x0:0x0/1200x0/webp/photo/p3/151/2024/11/10/IMG_20241110_071427-3099539862.jpg',
  ),
];

// ─────────────────────────────────────────────
// HOME SCREEN — Bottom Nav Controller
// ─────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const _BerandaPage(),
      const WisataPage(),
      const PesananScreen(),
      const KulinerScreen(),
      const ProfilScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGray,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.explore_outlined, 'label': 'Wisata'},
      {'icon': Icons.confirmation_number_outlined, 'label': 'Tiket'},
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
}

// ─────────────────────────────────────────────
// WISATA PAGE
// ─────────────────────────────────────────────

class WisataPage extends StatefulWidget {
  const WisataPage({super.key});

  @override
  State<WisataPage> createState() => _WisataPageState();
}

class _WisataPageState extends State<WisataPage> {
  String _selectedCategory = 'Semua';
  final List<String> _categories = ['Semua', 'Pantai', 'Pegunungan'];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<WisataItem> get _filtered {
    return wisataList.where((item) {
      final matchCat =
          _selectedCategory == 'Semua' || item.category == _selectedCategory;
      final matchSearch =
          _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.location.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Jelajahi Jember',
          style: TextStyle(
            color: kPrimaryGreen,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(
              children: [
                // Search bar
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: kInputBg,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: const TextStyle(fontSize: 14, color: kTextColor),
                    decoration: const InputDecoration(
                      hintText: 'Cari destinasi impianmu...',
                      hintStyle: TextStyle(color: kHintColor, fontSize: 14),
                      prefixIcon: Icon(
                        Icons.search,
                        color: kHintColor,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Category chips
                Row(
                  children: _categories.map((cat) {
                    final isActive = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isActive ? kPrimaryGreen : Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: isActive
                                  ? kPrimaryGreen
                                  : const Color(0xFFDDDDDD),
                            ),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isActive ? Colors.white : kHintColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 52, color: kHintColor),
                        SizedBox(height: 12),
                        Text(
                          'Tidak ada wisata ditemukan',
                          style: TextStyle(color: kHintColor, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      return _WisataCard(
                        item: _filtered[index],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BookingScreen(),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _WisataCard extends StatelessWidget {
  final WisataItem item;
  final VoidCallback onTap;

  const _WisataCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.network(
              item.imageUrl,
              height: 175,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 175,
                color: kInputBg,
                child: const Icon(Icons.image, color: kHintColor, size: 40),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + category badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: kTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.category,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Location
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: kHintColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.location,
                        style: const TextStyle(fontSize: 12, color: kHintColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Price + arrow button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'HTM/Orang',
                          style: TextStyle(fontSize: 11, color: kHintColor),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Rp ${_formatPrice(item.price)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: kPrimaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5F0),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: kPrimaryGreen,
                          size: 20,
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

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }
}

// ─────────────────────────────────────────────
// BERANDA PAGE
// ─────────────────────────────────────────────

class _BerandaPage extends StatelessWidget {
  const _BerandaPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGray,
      appBar: AppBar(
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
            child: CircleAvatar(
              radius: 18,
              backgroundImage: const NetworkImage(
                'https://i.pravatar.cc/100?img=47',
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildCategories(context),
            const SizedBox(height: 20),
            _buildPromoSection(),
            const SizedBox(height: 24),
            _buildPopularHeader(),
            const SizedBox(height: 12),
            _buildFeaturedCard(context),
            const SizedBox(height: 12),
            _buildGridCards(),
            const SizedBox(height: 16),
            _buildNearbyBanner(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

  final List<Map<String, dynamic>> _categories = const [
    {
      'icon': Icons.confirmation_number_outlined,
      'label': 'Tiket Wisata',
      'color': Color(0xFF6ECFB0),
      'route': 'booking',
    },
    {
      'icon': Icons.restaurant_menu,
      'label': 'Kuliner\nSekitar',
      'color': Color(0xFFF5D59E),
      'route': '',
    },
    {
      'icon': Icons.hotel_outlined,
      'label': 'Penginapan\nTerdekat',
      'color': Color(0xFF89C4E1),
      'route': 'penginapan',
    },
    {
      'icon': Icons.shopping_bag_outlined,
      'label': 'Pesanan',
      'color': Color(0xFFF5B87A),
      'route': '',
    },
    {
      'icon': Icons.history,
      'label': 'Riwayat',
      'color': Color(0xFFE0E0E0),
      'route': '',
    },
  ];

  Widget _buildCategories(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _categories.map((cat) {
          return GestureDetector(
            onTap: () {
              if (cat['route'] == 'booking') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BookingScreen()),
                );
              } else if (cat['route'] == 'penginapan') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PenginapanScreen()),
                );
              }
            },
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: cat['color'] as Color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    cat['icon'] as IconData,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  cat['label'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    color: kTextColor,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPromoSection() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: promoList.length,
        itemBuilder: (context, index) {
          final promo = promoList[index];
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
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
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
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

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

  // Card besar — popularList[0] — tampilan asli (row horizontal dengan gambar kiri)
  Widget _buildFeaturedCard(BuildContext context) {
    final item = popularList[0];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BookingScreen()),
        ),
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
              // Gambar kiri
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
                  errorBuilder: (_, __, ___) =>
                      Container(width: 130, color: kInputBg),
                ),
              ),
              // Info kanan
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
      ),
    );
  }

  // popularList[1..n] — horizontal scroll card kecil
  Widget _buildGridCards() {
    final items = popularList.skip(1).toList();
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20, right: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BookingScreen()),
            ),
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 12),
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
                  // Gambar atas
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    child: Image.network(
                      item.imageUrl,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(height: 100, color: kInputBg),
                    ),
                  ),
                  // Info bawah
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: kTextColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 11,
                                color: kHintColor,
                              ),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  item.location,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: kHintColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

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
          children: const [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
            Icon(Icons.chevron_right, color: kHintColor),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }
}

// ─────────────────────────────────────────────
// PENGINAPAN SCREEN
// ─────────────────────────────────────────────

class _PenginapanItem {
  final String name;
  final String location;
  final double rating;
  final int reviewCount;
  final int hargaPerMalam;
  final String imageUrl;
  final List<String> fasilitas;

  const _PenginapanItem({
    required this.name,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.hargaPerMalam,
    required this.imageUrl,
    required this.fasilitas,
  });
}

const List<_PenginapanItem> _penginapanList = [
  _PenginapanItem(
    name: 'Hotel Dafam Jember',
    location: 'Jl. PB Sudirman, Jember',
    rating: 4.7,
    reviewCount: 832,
    hargaPerMalam: 350000,
    imageUrl:
        'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
    fasilitas: ['WiFi', 'Kolam Renang', 'Parkir'],
  ),
  _PenginapanItem(
    name: 'The 1O1 Jember',
    location: 'Jl. Hayam Wuruk, Jember',
    rating: 4.5,
    reviewCount: 614,
    hargaPerMalam: 275000,
    imageUrl:
        'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=400',
    fasilitas: ['WiFi', 'Sarapan', 'AC'],
  ),
  _PenginapanItem(
    name: 'Grand Wahid Hotel',
    location: 'Jl. Gajah Mada, Jember',
    rating: 4.3,
    reviewCount: 420,
    hargaPerMalam: 200000,
    imageUrl:
        'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=400',
    fasilitas: ['WiFi', 'Parkir', 'AC'],
  ),
  _PenginapanItem(
    name: 'Villa Kebun Teh Silo',
    location: 'Kecamatan Silo, Jember',
    rating: 4.8,
    reviewCount: 290,
    hargaPerMalam: 450000,
    imageUrl:
        'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400',
    fasilitas: ['WiFi', 'Pemandangan', 'Dapur'],
  ),
];

class PenginapanScreen extends StatefulWidget {
  const PenginapanScreen({super.key});

  @override
  State<PenginapanScreen> createState() => _PenginapanScreenState();
}

class _PenginapanScreenState extends State<PenginapanScreen> {
  String _selectedFilter = 'Semua';
  final List<String> _filters = ['Semua', 'Hotel', 'Villa', 'Guest House'];

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Penginapan Terdekat',
          style: TextStyle(
            color: kPrimaryGreen,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Header info & filter ──
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lokasi aktif
                Row(
                  children: const [
                    Icon(Icons.location_on, color: kPrimaryGreen, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Sekitar Jember',
                      style: TextStyle(
                        fontSize: 13,
                        color: kPrimaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '— 4 penginapan ditemukan',
                      style: TextStyle(fontSize: 12, color: kHintColor),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Filter chips
                SizedBox(
                  height: 34,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    itemBuilder: (_, i) {
                      final isActive = _selectedFilter == _filters[i];
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedFilter = _filters[i]),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: isActive ? kPrimaryGreen : Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: isActive
                                  ? kPrimaryGreen
                                  : const Color(0xFFDDDDDD),
                            ),
                          ),
                          child: Text(
                            _filters[i],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isActive ? Colors.white : kHintColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ── List penginapan ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              itemCount: _penginapanList.length,
              itemBuilder: (context, index) {
                final item = _penginapanList[index];
                return _PenginapanCard(item: item, formatPrice: _formatPrice);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PenginapanCard extends StatelessWidget {
  final _PenginapanItem item;
  final String Function(int) formatPrice;

  const _PenginapanCard({required this.item, required this.formatPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Gambar ──
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Stack(
              children: [
                Image.network(
                  item.imageUrl,
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(height: 170, color: kInputBg),
                ),
                // Wishlist button
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: kHintColor,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Info ──
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama + rating
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: kTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 3),
                        Text(
                          '${item.rating} (${item.reviewCount})',
                          style: const TextStyle(
                            fontSize: 12,
                            color: kHintColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // Lokasi
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: kHintColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.location,
                        style: const TextStyle(fontSize: 12, color: kHintColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Fasilitas chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: item.fasilitas.map((f) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        f,
                        style: const TextStyle(
                          fontSize: 11,
                          color: kPrimaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Harga + tombol pesan
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mulai dari',
                          style: TextStyle(fontSize: 11, color: kHintColor),
                        ),
                        const SizedBox(height: 2),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Rp ${formatPrice(item.hargaPerMalam)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimaryGreen,
                                ),
                              ),
                              const TextSpan(
                                text: ' /malam',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: kHintColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 38,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: const Text(
                          'Pesan',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
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
