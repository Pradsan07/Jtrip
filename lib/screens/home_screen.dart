import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'wisata_terdekat_screen.dart';
import 'booking_screen.dart';
import 'other_screens.dart';
import 'package:jtrip/services/api_service.dart';

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

class WisataItem {
  final String idWisata;
  final String name;
  final String location;
  final String category;
  final int price;
  final String imageUrl;
  final int bookingCount;
  final double? latitude;
  final double? longitude;

  WisataItem({
    required this.idWisata,
    required this.name,
    required this.location,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.bookingCount = 0,
    this.latitude,
    this.longitude,
  });

  factory WisataItem.fromJson(Map<String, dynamic> json) {
  String getString(List<String> keys, {String fallback = ''}) {
    for (final key in keys) {
      final value = json[key];

      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }

    return fallback;
  }

  int getInt(List<String> keys, {int fallback = 0}) {
    for (final key in keys) {
      final value = json[key];

      if (value is int) return value;
      if (value is num) return value.toInt();

      if (value != null) {
        final parsed = int.tryParse(value.toString());
        if (parsed != null) return parsed;
      }
    }

    return fallback;
  }

  double? getDouble(List<String> keys) {
    for (final key in keys) {
      final value = json[key];

      if (value is double) return value;
      if (value is num) return value.toDouble();

      if (value != null) {
        final parsed = double.tryParse(value.toString());
        if (parsed != null) return parsed;
      }
    }

    return null;
  }

  String buildImageUrl() {
    final value = getString([
      'foto',
      'image_url',
      'image',
      'gambar',
      'thumbnail',
    ]);

    if (value.isEmpty) return '';

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    return 'https://jtrip.biz.id/uploads/wisata/$value';
  }

  return WisataItem(
    idWisata: getString(['id_wisata', 'idWisata', 'id']),
    name: getString(['nama', 'name', 'nama_wisata'], fallback: 'Wisata'),
    location: getString([
      'lokasi',
      'location_name',
      'location',
      'alamat',
    ]),
    category: getString([
      'kategori',
      'category',
      'jenis',
    ], fallback: 'Wisata'),
    price: getInt([
      'harga',
      'price',
      'harga_tiket',
    ]),
    imageUrl: buildImageUrl(),
    bookingCount: getInt([
      'jumlah_pemesanan',
      'booking_count',
      'total_booking',
    ]),
    latitude: getDouble(['latitude', 'lat']),
    longitude: getDouble(['longitude', 'lng', 'long']),
  );
}
}

// ─────────────────────────────────────────────
// DATA STATIS PROMO HOME
// ─────────────────────────────────────────────

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _orderMode = 'riwayat';
  String _wisataInitialSearch = '';

  void _goToWisata({String query = ''}) {
    setState(() {
      _wisataInitialSearch = query;
      _currentIndex = 1;
    });
  }

  void _goToPesanan() {
    setState(() {
      _orderMode = 'pesanan';
      _currentIndex = 2;
    });
  }

  void _goToRiwayat() {
    setState(() {
      _orderMode = 'riwayat';
      _currentIndex = 2;
    });
  }

  void _goToProfil() {
    setState(() {
      _currentIndex = 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _BerandaPage(
        onGoToWisata: () => _goToWisata(),
        onSearchWisata: (query) => _goToWisata(query: query),
        onGoToPesanan: _goToPesanan,
        onGoToRiwayat: _goToRiwayat,
        onGoToProfil: _goToProfil,
      ),
      WisataPage(
        key: ValueKey(_wisataInitialSearch),
        initialSearch: _wisataInitialSearch,
      ),
      PesananScreen(mode: _orderMode),
      const KulinerScreen(),
      const ProfilScreen(),
    ];

    return Scaffold(
      backgroundColor: kBgGray,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
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
                onTap: () {
                  setState(() {
                    _currentIndex = index;

                    if (index == 1) {
                      _wisataInitialSearch = '';
                    }

                    if (index == 2) {
                      _orderMode = 'riwayat';
                    }
                  });
                },
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
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.normal,
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
  final String initialSearch;

  const WisataPage({
    super.key,
    this.initialSearch = '',
  });

  @override
  State<WisataPage> createState() => _WisataPageState();
}

class _WisataPageState extends State<WisataPage> {
  String _selectedCategory = 'Semua';

  final List<String> _categories = [
    'Semua',
    'Pantai',
    'Air Terjun',
    'Kebun',
    'Wisata',
  ];

  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  late Future<List<WisataItem>> _futureWisata;
  List<WisataItem> _allWisata = [];

  @override
void initState() {
  super.initState();

  _searchQuery = widget.initialSearch;
  _searchController.text = widget.initialSearch;

  _futureWisata = _loadWisata();
}

@override
void didUpdateWidget(covariant WisataPage oldWidget) {
  super.didUpdateWidget(oldWidget);

  if (oldWidget.initialSearch != widget.initialSearch) {
    setState(() {
      _searchQuery = widget.initialSearch;
      _searchController.text = widget.initialSearch;
    });
  }
}

  Future<List<WisataItem>> _loadWisata() async {
    final data = await ApiService.getWisata();

    final list = data
        .whereType<Map<String, dynamic>>()
        .map((item) => WisataItem.fromJson(item))
        .toList();

    _allWisata = list;

    return list;
  }

  Future<void> _refreshWisata() async {
    setState(() {
      _futureWisata = _loadWisata();
    });

    await _futureWisata;
  }

  List<WisataItem> get _filtered {
    return _allWisata.where((item) {
      final itemCategory = item.category.toLowerCase();
      final selected = _selectedCategory.toLowerCase();

      final matchCat =
          _selectedCategory == 'Semua' || itemCategory == selected;

      final matchSearch =
          _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.location.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchCat && matchSearch;
    }).toList();
  }

  void _openBooking(WisataItem item) {
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
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: kInputBg,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    style: const TextStyle(
                      fontSize: 14,
                      color: kTextColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Cari destinasi impianmu...',
                      hintStyle: TextStyle(
                        color: kHintColor,
                        fontSize: 14,
                      ),
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((cat) {
                      final isActive = _selectedCategory == cat;

                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          },
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
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<WisataItem>>(
              future: _futureWisata,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryGreen,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return RefreshIndicator(
                    color: kPrimaryGreen,
                    onRefresh: _refreshWisata,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(24),
                      children: [
                        const SizedBox(height: 120),
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 54,
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Gagal memuat data wisata',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: kTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error
                              .toString()
                              .replaceFirst('Exception: ', ''),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: kHintColor,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final items = _filtered;

                if (items.isEmpty) {
                  return RefreshIndicator(
                    color: kPrimaryGreen,
                    onRefresh: _refreshWisata,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 160),
                        Icon(
                          Icons.search_off,
                          size: 52,
                          color: kHintColor,
                        ),
                        SizedBox(height: 12),
                        Center(
                          child: Text(
                            'Tidak ada wisata ditemukan',
                            style: TextStyle(
                              color: kHintColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: kPrimaryGreen,
                  onRefresh: _refreshWisata,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return _WisataCard(
                        item: item,
                        onTap: () => _openBooking(item),
                      );
                    },
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

  const _WisataCard({
    required this.item,
    required this.onTap,
  });

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  Widget _imageFallback() {
    return Container(
      height: 175,
      width: double.infinity,
      color: kInputBg,
      child: const Icon(
        Icons.image,
        color: kHintColor,
        size: 40,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: item.imageUrl.isEmpty
                  ? _imageFallback()
                  : Image.network(
                      item.imageUrl,
                      height: 175,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _imageFallback(),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          style: const TextStyle(
                            fontSize: 12,
                            color: kHintColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'HTM/Orang',
                            style: TextStyle(
                              fontSize: 11,
                              color: kHintColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.price == 0
                                ? 'Gratis'
                                : 'Rp ${_formatPrice(item.price)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: kPrimaryGreen,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
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
                    ],
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

// ─────────────────────────────────────────────
// BERANDA PAGE
// ─────────────────────────────────────────────

class _BerandaPage extends StatefulWidget {
  final VoidCallback onGoToWisata;
  final ValueChanged<String> onSearchWisata;
  final VoidCallback onGoToPesanan;
  final VoidCallback onGoToRiwayat;
  final VoidCallback onGoToProfil;

  const _BerandaPage({
    required this.onGoToWisata,
    required this.onSearchWisata,
    required this.onGoToPesanan,
    required this.onGoToRiwayat,
    required this.onGoToProfil,
  });

  @override
  State<_BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<_BerandaPage> {
  String _namaUser = 'Sobat Jember';
  String? _avatarUrl;

  final TextEditingController _homeSearchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _homeSearchController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    try {
      final result = await ApiService.me();
      final dynamic data = result['data'] ?? result['user'];

      if (data is Map) {
        final name = data['name']?.toString() ?? 'Sobat Jember';
        final avatar = data['avatar']?.toString();

        if (!mounted) return;

        setState(() {
          _namaUser = name.isEmpty ? 'Sobat Jember' : name;
          _avatarUrl = avatar != null && avatar.isNotEmpty ? avatar : null;
        });
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _namaUser = 'Sobat Jember';
        _avatarUrl = null;
      });
    }
  }

  void _showQuickMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 18),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Menu Cepat',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: kTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _QuickMenuTile(
                  icon: Icons.explore_outlined,
                  title: 'Cari Wisata',
                  subtitle: 'Lihat semua destinasi wisata',
                  onTap: () {
                    Navigator.pop(context);
                    widget.onGoToWisata();
                  },
                ),
                _QuickMenuTile(
                  icon: Icons.confirmation_number_outlined,
                  title: 'Pesanan Aktif',
                  subtitle: 'Lanjutkan pembayaran tiket pending',
                  onTap: () {
                    Navigator.pop(context);
                    widget.onGoToPesanan();
                  },
                ),
                _QuickMenuTile(
                  icon: Icons.history,
                  title: 'Riwayat Pesanan',
                  subtitle: 'Lihat tiket yang sudah dibayar',
                  onTap: () {
                    Navigator.pop(context);
                    widget.onGoToRiwayat();
                  },
                ),
                _QuickMenuTile(
                  icon: Icons.person_outline,
                  title: 'Profil Saya',
                  subtitle: 'Lihat dan ubah data akun',
                  onTap: () {
                    Navigator.pop(context);
                    widget.onGoToProfil();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _goToWisataTab(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Silakan pilih wisata yang ingin dipesan.'),
        backgroundColor: kPrimaryGreen,
      ),
    );

    widget.onGoToWisata();
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

  Future<void> _openNearestWisata(BuildContext context) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('GPS belum aktif. Aktifkan lokasi terlebih dahulu.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Izin lokasi ditolak.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Izin lokasi ditolak permanen. Buka pengaturan aplikasi.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mengambil lokasi kamu...'),
          backgroundColor: kPrimaryGreen,
          duration: Duration(seconds: 1),
        ),
      );

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final data = await ApiService.getWisata();

      final items = data
          .whereType<Map<String, dynamic>>()
          .map((item) => WisataItem.fromJson(item))
          .where((item) => item.latitude != null && item.longitude != null)
          .toList();

      if (items.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Belum ada data koordinat wisata.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final nearbyItems = items.map((item) {
        final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          item.latitude!,
          item.longitude!,
        );

        return NearbyWisataItem(
          wisata: item,
          distanceMeter: distance,
        );
      }).toList();

      nearbyItems.sort(
        (a, b) => a.distanceMeter.compareTo(b.distanceMeter),
      );

      if (!context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WisataTerdekatScreen(
            items: nearbyItems,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil wisata terdekat: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  Widget _popularImageFallback({
    double? width,
    required double height,
  }) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      color: kInputBg,
      child: const Icon(
        Icons.image,
        color: kHintColor,
      ),
    );
  }

  Widget _buildHomeAvatar() {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: const Color(0xFFE8F5F0),
        backgroundImage: _avatarUrl != null ? NetworkImage(_avatarUrl!) : null,
        child: _avatarUrl == null
            ? const Icon(
                Icons.person,
                color: kPrimaryGreen,
                size: 20,
              )
            : null,
      ),
    );
  }

  void _submitHomeSearch() {
    final query = _homeSearchController.text.trim();

    if (query.isEmpty) {
      widget.onGoToWisata();
    } else {
      widget.onSearchWisata(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.grid_view_rounded,
            color: kTextColor,
          ),
          onPressed: () => _showQuickMenu(context),
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
          GestureDetector(
            onTap: widget.onGoToProfil,
            child: _buildHomeAvatar(),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: kPrimaryGreen,
        onRefresh: _loadUser,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
              _buildPopularSection(context),
              const SizedBox(height: 16),
              _buildNearbyBanner(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Halo, $_namaUser',
            style: const TextStyle(
              fontSize: 13,
              color: kHintColor,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
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
        child: TextField(
          controller: _homeSearchController,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _submitHomeSearch(),
          style: const TextStyle(
            fontSize: 14,
            color: kTextColor,
          ),
          decoration: InputDecoration(
            hintText: 'Cari destinasi wisata...',
            hintStyle: const TextStyle(
              color: kHintColor,
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: kHintColor,
              size: 20,
            ),
            suffixIcon: IconButton(
              onPressed: _submitHomeSearch,
              icon: const Icon(
                Icons.arrow_forward_rounded,
                color: kPrimaryGreen,
                size: 20,
              ),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _categories => const [
  {
    'icon': Icons.confirmation_number_rounded,
    'label': 'Tiket\nWisata',
    'color': kPrimaryGreen,
    'iconColor': Colors.white,
    'route': 'booking',
  },
  {
    'icon': Icons.storefront_rounded,
    'label': 'UMKM\nSekitar',
    'color': Color(0xFFF2B84B),
    'iconColor': Colors.white,
    'route': 'umkm',
  },
  {
    'icon': Icons.receipt_long_rounded,
    'label': 'Pesanan\nAktif',
    'color': Color(0xFFF28C38),
    'iconColor': Colors.white,
    'route': 'pesanan',
  },
  {
    'icon': Icons.history_rounded,
    'label': 'Riwayat\nTiket',
    'color': Color(0xFF7A7A7A),
    'iconColor': Colors.white,
    'route': 'riwayat',
  },
];

  Widget _buildCategories(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _categories.map((cat) {
          return GestureDetector(
            onTap: () {
              if (cat['route'] == 'booking') {
                _goToWisataTab(context);
              } else if (cat['route'] == 'umkm') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const KulinerScreen(),
                  ),
                );
              } else if (cat['route'] == 'pesanan') {
                widget.onGoToPesanan();
              } else if (cat['route'] == 'riwayat') {
                widget.onGoToRiwayat();
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 18),
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
                    errorBuilder: (_, __, ___) => Container(
                      color: kInputBg,
                    ),
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

  Widget _buildPopularSection(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: ApiService.getWisataPopuler(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: CircularProgressIndicator(
                color: kPrimaryGreen,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data ?? [];

        final items = data
            .whereType<Map<String, dynamic>>()
            .map((item) => WisataItem.fromJson(item))
            .toList();

        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        final featured = items.first;
        final others = items.skip(1).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPopularHeader(context),
            const SizedBox(height: 12),
            _buildPopularFeaturedCard(context, featured),
            if (others.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildPopularGridCards(context, others),
            ],
          ],
        );
      },
    );
  }

  Widget _buildPopularHeader(BuildContext context) {
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
            onTap: () => _goToWisataTab(context),
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

  Widget _buildPopularFeaturedCard(BuildContext context, WisataItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => _openBooking(context, item),
        child: Container(
          height: 150,
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
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: item.imageUrl.isEmpty
                    ? _popularImageFallback(width: 140, height: 150)
                    : Image.network(
                        item.imageUrl,
                        width: 140,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _popularImageFallback(width: 140, height: 150),
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: Colors.orange,
                            size: 15,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${item.bookingCount} pemesanan',
                            style: const TextStyle(
                              fontSize: 12,
                              color: kHintColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: kTextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: kHintColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.price == 0
                            ? 'Gratis'
                            : 'Rp ${_formatPrice(item.price)}',
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

  Widget _buildPopularGridCards(BuildContext context, List<WisataItem> items) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20, right: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return GestureDetector(
            onTap: () => _openBooking(context, item),
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
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    child: item.imageUrl.isEmpty
                        ? _popularImageFallback(height: 100)
                        : Image.network(
                            item.imageUrl,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _popularImageFallback(height: 100),
                          ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: kTextColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${item.bookingCount} pemesanan',
                            style: const TextStyle(
                              fontSize: 10,
                              color: kHintColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.price == 0
                                ? 'Gratis'
                                : 'Rp ${_formatPrice(item.price)}',
                            style: const TextStyle(
                              fontSize: 11,
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
        },
      ),
    );
  }

  Widget _buildNearbyBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => _openNearestWisata(context),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE8E8E8),
            ),
          ),
          child: const Row(
            children: [
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
                      'Gunakan GPS untuk menemukan destinasi terdekat',
                      style: TextStyle(
                        fontSize: 12,
                        color: kHintColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.my_location,
                color: kPrimaryGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5F0),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: kPrimaryGreen,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: kTextColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: kHintColor,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: kHintColor,
      ),
    );
  }
}

