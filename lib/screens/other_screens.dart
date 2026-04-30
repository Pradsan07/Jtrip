import 'dart:io';
import 'package:flutter/material.dart';
import 'edit_profil_screen.dart';

const kPrimaryGreen = Color(0xFF2D6A4F);
const kBgGray = Color(0xFFF5F5F5);
const kInputBg = Color(0xFFEAEAEA);
const kHintColor = Color(0xFFAAAAAA);
const kTextColor = Color(0xFF1A1A1A);

// ─────────────────────────────────────────────
// KULINER SCREEN
// ─────────────────────────────────────────────

class KulinerScreen extends StatelessWidget {
  const KulinerScreen({super.key});

  final List<Map<String, dynamic>> _kulinerList = const [
    {
      'name': 'Ikan Bakar',
      'distance': '200m',
      'rating': 4.8,
      'reviews': 120,
      'image':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
    },
    {
      'name': 'Sate Kelinci',
      'distance': '350m',
      'rating': 4.6,
      'reviews': 85,
      'image':
          'https://images.unsplash.com/photo-1544025162-d76694265947?w=400',
    },
    {
      'name': 'Rujak Soto',
      'distance': '500m',
      'rating': 4.9,
      'reviews': 200,
      'image':
          'https://images.unsplash.com/photo-1569050467447-ce54b3bbc37d?w=400',
    },
  ];

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active ticket banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5F0),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: kPrimaryGreen.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: kPrimaryGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.confirmation_number_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tiket Aktif',
                        style: TextStyle(
                          fontSize: 12,
                          color: kPrimaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        'Pantai Papuma - Berlaku Hari Ini',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: kTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: kPrimaryGreen.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Terverifikasi',
                          style: TextStyle(
                            fontSize: 11,
                            color: kPrimaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Header
            const Text(
              'Kuliner Sekitar Pantai Papuma',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: kTextColor,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Nikmati hidangan laut segar dan makanan khas\nJember langsung di tepi pantai',
              style: TextStyle(fontSize: 12, color: kHintColor, height: 1.4),
            ),
            const SizedBox(height: 16),

            // Kuliner list
            ..._kulinerList.map((item) => _KulinerCard(item: item)).toList(),
          ],
        ),
      ),
    );
  }
}

class _KulinerCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _KulinerCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              item['image'],
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: kInputBg,
                child: const Icon(Icons.restaurant, color: kHintColor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: kTextColor,
                  ),
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
                    Text(
                      item['distance'],
                      style: const TextStyle(fontSize: 13, color: kHintColor),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${item['rating']} (${item['reviews']}+)',
                      style: const TextStyle(fontSize: 13, color: kHintColor),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Lihat lokasi',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PESANAN SCREEN
// ─────────────────────────────────────────────

class PesananScreen extends StatelessWidget {
  const PesananScreen({super.key});

  final List<Map<String, dynamic>> _orders = const [
    {
      'name': 'Pantai Papuma',
      'status': 'Selesai',
      'date': '15 April 2026',
      'price': 'Rp 50.000',
      'statusColor': Color(0xFF2D6A4F),
      'statusBg': Color(0xFFE8F5F0),
    },
    {
      'name': 'Puncak Rembangan',
      'status': 'Terjadwal',
      'date': '15 Mei 2026',
      'price': 'Rp 50.000',
      'statusColor': Color(0xFFE08C00),
      'statusBg': Color(0xFFFFF8E1),
    },
  ];

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Riwayat Pesanan',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: kTextColor,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Kenangan Perjalanan dan kuliner anda di Jember',
              style: TextStyle(fontSize: 13, color: kHintColor),
            ),
            const SizedBox(height: 20),

            ..._orders.map((order) => _OrderCard(order: order)).toList(),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.confirmation_number_outlined,
                  color: kPrimaryGreen,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  order['name'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: kTextColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: order['statusBg'],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order['status'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: order['statusColor'],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tanggal Kunjungan',
                      style: TextStyle(fontSize: 12, color: kHintColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order['date'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: kTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total Pembayaran',
                    style: TextStyle(fontSize: 12, color: kHintColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order['price'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: kTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE0E0E0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Text(
                'Lihat E-Tiket',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PROFIL SCREEN
// ─────────────────────────────────────────────

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  String _nama = 'Nama Pengguna';
  String _username = 'username';
  String _email = 'email_pengguna@pengguna.com';
  String _noTelp = '+62 812-3456-7890';
  String? _fotoUrl = 'https://i.pravatar.cc/200?img=47';
  File? _fotoFile;

  final List<Map<String, dynamic>> _wishlist = const [
    {
      'image':
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300',
      'name': 'Pantai Papuma',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?w=300',
      'name': 'Pantai Papuma',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1431794062232-2a99a5431c6c?w=300',
      'name': 'Pantai Papum',
    },
  ];

  Future<void> _bukaEditProfil(BuildContext context) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilScreen(
          nama: _nama,
          username: _username,
          email: _email,
          noTelp: _noTelp,
          fotoUrl: _fotoUrl,
          fotoFile: _fotoFile,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _nama = result['nama'] ?? _nama;
        _username = result['username'] ?? _username;
        _email = result['email'] ?? _email;
        _noTelp = result['noTelp'] ?? _noTelp;
        _fotoFile = result['fotoFile'];
        if (_fotoFile == null && result.containsKey('fotoFile')) {
          _fotoUrl = null;
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Profil berhasil diperbarui ✓',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: kPrimaryGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Widget _buildAvatar() {
    Widget image;
    if (_fotoFile != null) {
      image = Image.file(_fotoFile!, fit: BoxFit.cover);
    } else if (_fotoUrl != null) {
      image = Image.network(
        _fotoUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.person, size: 50, color: kHintColor),
      );
    } else {
      image = Container(
        color: const Color(0xFFE8F5F0),
        child: const Icon(Icons.person_rounded, color: kPrimaryGreen, size: 50),
      );
    }
    return Stack(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kPrimaryGreen, width: 2.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: image,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: kPrimaryGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit, color: Colors.white, size: 14),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {'icon': Icons.person_outline, 'label': 'Edit Profil', 'isLast': false},
      {'icon': Icons.lock_outline, 'label': 'Ganti Password', 'isLast': false},
      {'icon': Icons.logout, 'label': 'Log out', 'isLast': true},
    ];

    return Scaffold(
      backgroundColor: kBgGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: kPrimaryGreen,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _bukaEditProfil(context),
              child: _buildAvatar(),
            ),
            const SizedBox(height: 14),

            Text(
              _nama,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: kTextColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '@$_username',
              style: const TextStyle(fontSize: 14, color: kHintColor),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.mail_outline, size: 16, color: kHintColor),
                const SizedBox(width: 6),
                Text(
                  _email,
                  style: const TextStyle(fontSize: 13, color: kHintColor),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.phone_outlined, size: 16, color: kHintColor),
                const SizedBox(width: 6),
                Text(
                  _noTelp,
                  style: const TextStyle(fontSize: 13, color: kHintColor),
                ),
              ],
            ),
            const SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Wishlist',
                  style: TextStyle(
                    fontSize: 16,
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
                      color: kPrimaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: _wishlist.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index < _wishlist.length - 1 ? 8 : 0,
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item['image'],
                                height: 85,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    Container(height: 85, color: kInputBg),
                              ),
                            ),
                            const Positioned(
                              top: 6,
                              right: 6,
                              child: Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['name'],
                          style: const TextStyle(
                            fontSize: 11,
                            color: kTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: List.generate(menuItems.length, (index) {
                  final item = menuItems[index];
                  final isLast = item['isLast'] as bool;
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          item['icon'] as IconData,
                          color: isLast ? Colors.red : kTextColor,
                          size: 22,
                        ),
                        title: Text(
                          item['label'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isLast ? Colors.red : kTextColor,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: kHintColor,
                          size: 20,
                        ),
                        onTap: () {
                          if (index == 0) {
                            _bukaEditProfil(context);
                          } else if (isLast) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                          }
                        },
                      ),
                      if (!isLast)
                        const Divider(
                          height: 1,
                          indent: 56,
                          color: Color(0xFFF0F0F0),
                        ),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
