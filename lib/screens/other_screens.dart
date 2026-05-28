import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'edit_profil_screen.dart';
import 'order_store.dart';
import 'e_ticket_screen.dart';
import 'package:jtrip/services/api_service.dart';
import 'package:jtrip/services/session_service.dart';
import 'admin_scan_screen.dart';

const kPrimaryGreen = Color(0xFF2D6A4F);
const kBgGray = Color(0xFFF5F5F5);
const kInputBg = Color(0xFFEAEAEA);
const kHintColor = Color(0xFFAAAAAA);
const kTextColor = Color(0xFF1A1A1A);




class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordCtrl = TextEditingController();
  final TextEditingController _newPasswordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : kPrimaryGreen,
      ),
    );
  }

  Future<void> _submit() async {
    final currentPassword = _currentPasswordCtrl.text.trim();
    final newPassword = _newPasswordCtrl.text.trim();
    final confirmPassword = _confirmPasswordCtrl.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _showSnack('Semua field wajib diisi.', isError: true);
      return;
    }

    if (newPassword.length < 8) {
      _showSnack('Password baru minimal 8 karakter.', isError: true);
      return;
    }

    if (newPassword != confirmPassword) {
      _showSnack('Konfirmasi password baru tidak sama.', isError: true);
      return;
    }

    if (currentPassword == newPassword) {
      _showSnack('Password baru tidak boleh sama dengan password lama.',
          isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: confirmPassword,
      );

      if (!mounted) return;

      _showSnack(
        result['message']?.toString() ?? 'Password berhasil diperbarui.',
      );

      Navigator.pop(context);
    } on ApiException catch (e) {
      _showSnack(e.message, isError: true);
    } catch (e) {
      _showSnack(
        e.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _passwordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: kTextColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: kHintColor,
              fontSize: 13,
            ),
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: kHintColor,
              size: 20,
            ),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: kHintColor,
                size: 20,
              ),
            ),
            filled: true,
            fillColor: kInputBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: kPrimaryGreen,
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Ganti Password',
          style: TextStyle(
            color: kPrimaryGreen,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5F0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_reset_outlined,
                color: kPrimaryGreen,
                size: 42,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Perbarui Password',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: kTextColor,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Masukkan password lama dan password baru untuk menjaga keamanan akun kamu.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: kHintColor,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _passwordField(
                    label: 'Password Lama',
                    hint: 'Masukkan password lama',
                    controller: _currentPasswordCtrl,
                    obscure: !_showCurrentPassword,
                    onToggle: () {
                      setState(() {
                        _showCurrentPassword = !_showCurrentPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  _passwordField(
                    label: 'Password Baru',
                    hint: 'Minimal 8 karakter',
                    controller: _newPasswordCtrl,
                    obscure: !_showNewPassword,
                    onToggle: () {
                      setState(() {
                        _showNewPassword = !_showNewPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  _passwordField(
                    label: 'Konfirmasi Password Baru',
                    hint: 'Ulangi password baru',
                    controller: _confirmPasswordCtrl,
                    obscure: !_showConfirmPassword,
                    onToggle: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryGreen,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: kHintColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.4,
                        ),
                      )
                    : const Text(
                        'Simpan Password',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ─────────────────────────────────────────────
// UMKM SCREEN
// ─────────────────────────────────────────────

class UmkmItem {
  final String idUmkm;
  final String nama;
  final String pemilik;
  final String deskripsi;
  final String? gambar;
  final String? idWisata;
  final String? namaWisata;
  final String? lokasiWisata;
  final double? latitude;
  final double? longitude;

  UmkmItem({
    required this.idUmkm,
    required this.nama,
    required this.pemilik,
    required this.deskripsi,
    required this.idWisata,
    required this.namaWisata,
    required this.lokasiWisata,
    this.latitude,
    this.longitude,
    this.gambar,
  });

  factory UmkmItem.fromJson(Map<String, dynamic> json) {
  final wisata = json['wisata'] is Map ? json['wisata'] as Map : {};

  String? buildGambarUrl() {
    final value = json['gambar']?.toString() ??
        json['image']?.toString() ??
        json['image_url']?.toString();

    if (value == null || value.trim().isEmpty) return null;

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    return 'https://jtrip.biz.id/uploads/umkm/$value';
  }

  return UmkmItem(
    idUmkm: json['id_umkm']?.toString() ?? '',
    nama: json['nama']?.toString() ?? 'UMKM',
    pemilik: json['pemilik']?.toString() ?? '-',
    deskripsi: json['deskripsi']?.toString() ?? '',
    gambar: buildGambarUrl(),
    idWisata: json['id_wisata']?.toString(),
    namaWisata: wisata['name']?.toString() ??
        wisata['nama']?.toString(),
    lokasiWisata: wisata['location_name']?.toString() ??
        wisata['lokasi']?.toString(),
    latitude: double.tryParse(json['latitude']?.toString() ?? ''),
    longitude: double.tryParse(json['longitude']?.toString() ?? ''),
  );
}
}

class KulinerScreen extends StatefulWidget {
  const KulinerScreen({super.key});

  @override
  State<KulinerScreen> createState() => _KulinerScreenState();
}

class _KulinerScreenState extends State<KulinerScreen> {
  late Future<List<UmkmItem>> _futureUmkm;

  @override
  void initState() {
    super.initState();
    _futureUmkm = _loadUmkm();
  }

  Future<List<UmkmItem>> _loadUmkm() async {
    final data = await ApiService.getUmkm();

    return data
        .whereType<Map<String, dynamic>>()
        .map((item) => UmkmItem.fromJson(item))
        .toList();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureUmkm = _loadUmkm();
    });

    await _futureUmkm;
  }

  Future<void> _openMaps(UmkmItem item) async {
    if (item.latitude == null || item.longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Koordinat UMKM belum tersedia.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${item.latitude},${item.longitude}',
    );

    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak bisa membuka Google Maps.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'UMKM Sekitar',
          style: TextStyle(
            color: kPrimaryGreen,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<UmkmItem>>(
        future: _futureUmkm,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: kPrimaryGreen),
            );
          }

          if (snapshot.hasError) {
            return RefreshIndicator(
              color: kPrimaryGreen,
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 130),
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 54,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Gagal memuat data UMKM',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: kTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString().replaceFirst('Exception: ', ''),
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

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return RefreshIndicator(
              color: kPrimaryGreen,
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                children: const [
                  SizedBox(height: 150),
                  Icon(
                    Icons.storefront_outlined,
                    color: kHintColor,
                    size: 58,
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Belum ada data UMKM',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: kTextColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Data UMKM yang ditambahkan admin akan muncul di sini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: kHintColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: kPrimaryGreen,
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'UMKM Lokal',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: kTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'UMKM yang ditambahkan admin akan tampil di halaman ini.',
                  style: TextStyle(
                    fontSize: 13,
                    color: kHintColor,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                ...items.map(
                  (item) => _UmkmCard(
                    item: item,
                    onOpenMaps: () => _openMaps(item),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _UmkmCard extends StatelessWidget {
  final UmkmItem item;
  final VoidCallback onOpenMaps;

  const _UmkmCard({
    required this.item,
    required this.onOpenMaps,
  });

  @override
  Widget build(BuildContext context) {
    final wisataName = item.namaWisata?.isNotEmpty == true
        ? item.namaWisata!
        : 'Wisata belum dipilih';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: item.gambar != null && item.gambar!.isNotEmpty
                      ? Image.network(
                          item.gambar!,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 64,
                            height: 64,
                            color: const Color(0xFFE8F5F0),
                            child: const Icon(
                              Icons.storefront_outlined,
                              color: kPrimaryGreen,
                              size: 28,
                            ),
                          ),
                        )
                      : Container(
                          width: 64,
                          height: 64,
                          color: const Color(0xFFE8F5F0),
                          child: const Icon(
                            Icons.storefront_outlined,
                            color: kPrimaryGreen,
                            size: 28,
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nama,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: kTextColor,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Pemilik: ${item.pemilik}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: kHintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (item.deskripsi.isNotEmpty)
              Text(
                item.deskripsi,
                style: const TextStyle(
                  fontSize: 13,
                  color: kHintColor,
                  height: 1.5,
                ),
              ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kBgGray,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.place_outlined,
                    color: kPrimaryGreen,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      wisataName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: kTextColor,
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (item.lokasiWisata != null && item.lokasiWisata!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                item.lokasiWisata!,
                style: const TextStyle(
                  fontSize: 12,
                  color: kHintColor,
                  height: 1.4,
                ),
              ),
            ],

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                onPressed: onOpenMaps,
                icon: const Icon(
                  Icons.map_outlined,
                  size: 18,
                ),
                label: const Text(
                  'Lihat Lokasi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kPrimaryGreen,
                  side: const BorderSide(color: kPrimaryGreen),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PESANAN SCREEN
// ─────────────────────────────────────────────

class RiwayatPesananModel {
  final String idTiket;
  final String kodeBooking;
  final String namaWisata;
  final String? imageUrl;
  final String tanggalKunjungan;
  final int jumlahPengunjung;
  final int grandTotal;
  final String status;
  final List<dynamic> detailTiket;
  final String? snapToken;
  final String? kodePesanan;
  final String statusPembayaran;

  RiwayatPesananModel({
    required this.idTiket,
    required this.kodeBooking,
    required this.namaWisata,
    required this.imageUrl,
    required this.tanggalKunjungan,
    required this.jumlahPengunjung,
    required this.grandTotal,
    required this.status,
    required this.detailTiket,
    required this.statusPembayaran,
    this.snapToken,
    this.kodePesanan,
  });

  factory RiwayatPesananModel.fromJson(Map<String, dynamic> json) {
  final wisata = json['wisata'] is Map ? json['wisata'] as Map : {};

  final transaksi = json['transaksi'] is Map
      ? Map<String, dynamic>.from(json['transaksi'] as Map)
      : <String, dynamic>{};

  final tiketStatus = json['status']?.toString().toLowerCase() ?? 'pending';

  final pembayaranStatus =
      transaksi['status_pembayaran']?.toString().toLowerCase() ??
      json['status_pembayaran']?.toString().toLowerCase() ??
      tiketStatus;

  String? buildImageUrl() {
    final value = wisata['foto']?.toString() ??
        wisata['image_url']?.toString() ??
        wisata['image']?.toString() ??
        wisata['gambar']?.toString();

    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    return 'https://jtrip.biz.id/uploads/wisata/$value';
  }

  return RiwayatPesananModel(
    idTiket: json['id_tiket']?.toString() ?? '',
    kodeBooking: json['kode_booking']?.toString() ?? '-',
    namaWisata: wisata['name']?.toString() ??
        wisata['nama']?.toString() ??
        wisata['nama_wisata']?.toString() ??
        'Wisata',
    imageUrl: buildImageUrl(),
    tanggalKunjungan: json['tanggal_kunjungan']?.toString() ?? '-',
    jumlahPengunjung: int.tryParse(
          json['jumlah_pengunjung']?.toString() ??
              json['jumlah']?.toString() ??
              '0',
        ) ??
        0,
    grandTotal: int.tryParse(
          json['grand_total']?.toString() ??
              json['total_harga']?.toString() ??
              '0',
        ) ??
        0,
    status: tiketStatus,
    statusPembayaran: pembayaranStatus,
    detailTiket: json['detail_tiket'] is List
        ? json['detail_tiket'] as List
        : json['detailTiket'] is List
            ? json['detailTiket'] as List
            : [],
    snapToken: transaksi['snap_token']?.toString() ??
        json['snap_token']?.toString(),
    kodePesanan: transaksi['kode_pesanan']?.toString() ??
        json['kode_pesanan']?.toString(),
  );
}

  String get formattedTotal {
    final s = grandTotal.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );

    return 'Rp $s';
  }

  String get statusLabel {
  if (status == 'used') return 'Used';

  if (statusPembayaran == 'paid' || status == 'paid') {
    return 'Paid';
  }

  if (statusPembayaran == 'failed') {
    return 'Failed';
  }

  return 'Pending';
}
bool get isPending {
  return statusPembayaran == 'pending' || status == 'pending';
}

bool get isPaid {
  return statusPembayaran == 'paid' || status == 'paid';
}

bool get isUsed {
  return status == 'used';
}

bool get isFailed {
  return statusPembayaran == 'failed';
}
}

class PesananScreen extends StatefulWidget {
  final String mode;

  const PesananScreen({
    super.key,
    this.mode = 'riwayat',
  });

  @override
  State<PesananScreen> createState() => _PesananScreenState();
}

class _PesananScreenState extends State<PesananScreen>
    with WidgetsBindingObserver {
  late Future<List<RiwayatPesananModel>> _futureRiwayat;
  late String _activeMode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _activeMode = widget.mode;
    _futureRiwayat = _loadRiwayat();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PesananScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.mode != widget.mode) {
      setState(() {
        _activeMode = widget.mode;
      });

      _refresh();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refresh();
    }
  }

  Future<List<RiwayatPesananModel>> _loadRiwayat() async {
    final data = await ApiService.getRiwayatPesanan();

    return data
        .whereType<Map<String, dynamic>>()
        .map((item) => RiwayatPesananModel.fromJson(item))
        .toList();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureRiwayat = _loadRiwayat();
    });

    await _futureRiwayat;
  }

  bool _matchMode(RiwayatPesananModel order) {
    if (_activeMode == 'pesanan') {
      return order.isPending;
    }

    return order.isPaid || order.isUsed || order.isFailed;
  }

  String get _pageTitle {
    return 'Tiket Saya';
  }

  String get _pageSubtitle {
    return _activeMode == 'pesanan'
        ? 'Daftar tiket yang masih menunggu pembayaran'
        : 'Daftar tiket yang sudah dibayar, digunakan, atau gagal';
  }

  String get _emptyTitle {
    return _activeMode == 'pesanan'
        ? 'Belum ada pesanan aktif'
        : 'Belum ada riwayat pesanan';
  }

  String get _emptySubtitle {
    return _activeMode == 'pesanan'
        ? 'Tiket pending atau belum dibayar\nakan muncul di sini'
        : 'Tiket paid, used, atau failed\nakan muncul di sini';
  }

  Widget _buildModeTabs() {
    final isPesanan = _activeMode == 'pesanan';
    final isRiwayat = _activeMode == 'riwayat';

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_activeMode == 'pesanan') return;

                setState(() {
                  _activeMode = 'pesanan';
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isPesanan ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isPesanan
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  'Pesanan Aktif',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isPesanan ? kPrimaryGreen : kHintColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_activeMode == 'riwayat') return;

                setState(() {
                  _activeMode = 'riwayat';
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isRiwayat ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isRiwayat
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  'Riwayat',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isRiwayat ? kPrimaryGreen : kHintColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<RiwayatPesananModel> orders) {
    return RefreshIndicator(
      color: kPrimaryGreen,
      onRefresh: _refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _activeMode == 'pesanan'
                  ? 'Pesanan yang Menunggu Pembayaran'
                  : 'Riwayat Transaksi Tiket',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: kTextColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _pageSubtitle,
              style: const TextStyle(
                fontSize: 13,
                color: kHintColor,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ...orders.map(
              (order) => _RiwayatOrderCard(order: order),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Colors.red),
            const SizedBox(height: 14),
            const Text(
              'Gagal memuat data tiket',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: kTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message.replaceFirst('Exception: ', ''),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: kHintColor,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _refresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      color: kPrimaryGreen,
      onRefresh: _refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5F0),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _activeMode == 'pesanan'
                        ? Icons.receipt_long_outlined
                        : Icons.history_rounded,
                    color: kPrimaryGreen,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _emptyTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: kTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _emptySubtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: kHintColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Tiket Saya',
          style: TextStyle(
            color: kPrimaryGreen,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildModeTabs(),
          Expanded(
            child: FutureBuilder<List<RiwayatPesananModel>>(
              future: _futureRiwayat,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: kPrimaryGreen),
                  );
                }

                if (snapshot.hasError) {
                  return _buildErrorState(snapshot.error.toString());
                }

                final allOrders = snapshot.data ?? [];
                final orders = allOrders.where(_matchMode).toList();

                if (orders.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildOrderList(orders);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RiwayatOrderCard extends StatelessWidget {
  final RiwayatPesananModel order;

  const _RiwayatOrderCard({required this.order});

  Future<void> _continuePayment(BuildContext context) async {
    final snapToken = order.snapToken;

    if (snapToken == null || snapToken.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Token pembayaran tidak ditemukan. Buat pesanan ulang.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final snapUrl = Uri.parse(
      'https://app.sandbox.midtrans.com/snap/v2/vtweb/$snapToken',
    );

    final opened = await launchUrl(
      snapUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak bisa membuka halaman pembayaran Midtrans.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _openETicket(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ETicketScreen(
          kodeBooking: order.kodeBooking,
          namaWisata: order.namaWisata,
          imageUrl: order.imageUrl,
          tanggalKunjungan: order.tanggalKunjungan,
          jumlahPengunjung: order.jumlahPengunjung,
          grandTotal: order.grandTotal,
          status: order.status,
          detailTiket: order.detailTiket,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPaid = order.isPaid;
    final isUsed = order.isUsed;
    final isPending = order.isPending;
    final isFailed = order.isFailed;

    final statusColor = isPaid
    ? kPrimaryGreen
    : isUsed
        ? Colors.grey
        : isFailed
            ? Colors.red
            : const Color(0xFFE08C00);

    final statusBg = isPaid 
    ? const Color(0xFFE8F5F0)
    : isUsed
        ? const Color(0xFFEDEDED)
        : isFailed
            ? const Color(0xFFFFEBEE)
            : const Color(0xFFFFF8E1);

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
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: order.imageUrl == null || order.imageUrl!.isEmpty
                    ? _imageFallback()
                    : Image.network(
                        order.imageUrl!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imageFallback(),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.namaWisata,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: kTextColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      order.kodeBooking,
                      style: const TextStyle(
                        fontSize: 11,
                        color: kHintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.statusLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
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
                child: _OrderInfo(
                  label: 'Tanggal Kunjungan',
                  value: order.tanggalKunjungan,
                  alignEnd: false,
                ),
              ),
              _OrderInfo(
                label: 'Total Pembayaran',
                value: order.formattedTotal,
                alignEnd: true,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Jumlah Tiket: ',
                style: TextStyle(fontSize: 11, color: kHintColor),
              ),
              Text(
                '${order.jumlahPengunjung} orang',
                style: const TextStyle(
                  fontSize: 11,
                  color: kHintColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton(
              onPressed: () {
              if (isPaid || isUsed) {
                _openETicket(context);
              } else if (isPending) {
                _continuePayment(context);
              } else if (isFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pesanan ini gagal. Silakan buat pesanan baru.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: kPrimaryGreen,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                isPending ? 'Lanjut Pembayaran' : 'Lihat E-Tiket',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryGreen,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5F0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.confirmation_number_outlined,
        color: kPrimaryGreen,
        size: 22,
      ),
    );
  }
}

class _OrderInfo extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;

  const _OrderInfo({
    required this.label,
    required this.value,
    required this.alignEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: kHintColor),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: kTextColor,
          ),
        ),
      ],
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
  String _nama = 'Memuat...';
  String _username = 'user';
  String _email = '-';
  String _noTelp = '-';
  String? _fotoUrl;
  File? _fotoFile;
  String _role = 'user';

  bool _isLoadingProfile = true;
  bool _isLoggingOut = false;

  final List<Map<String, dynamic>> _wishlist = const [
    {
      'image':
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300',
      'name': 'Pantai Papuma',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?w=300',
      'name': 'Pantai Watu Ulo',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1431794062232-2a99a5431c6c?w=300',
      'name': 'Rembangan',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileFromApi();
  }

  Future<void> _loadProfileFromApi() async {
    if (!mounted) return;

    setState(() {
      _isLoadingProfile = true;
    });

    try {
      final result = await ApiService.me();

      final dynamic data = result['data'] ?? result['user'];

      if (data is Map) {
        final name = data['name']?.toString() ?? 'Pengguna';
        final email = data['email']?.toString() ?? '-';
        final noTelp = data['no_telp']?.toString() ?? '-';
        final avatar = data['avatar']?.toString();

        String username = data['username']?.toString() ?? '';

        if (username.isEmpty && email.contains('@')) {
          username = email.split('@').first;
        }

        if (username.isEmpty) {
          username = name
              .toLowerCase()
              .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
              .replaceAll(RegExp(r'_+'), '_')
              .replaceAll(RegExp(r'^_|_$'), '');
        }

        if (!mounted) return;

        setState(() {
          _nama = name;
          _username = username.isEmpty ? 'user' : username;
          _email = email;
          _noTelp = noTelp;
          _fotoUrl = avatar != null && avatar.isNotEmpty ? avatar : null;
          _isLoadingProfile = false;
          _role = data['role']?.toString() ?? 'user';
        });
      } else {
        if (!mounted) return;

        setState(() {
          _nama = 'Pengguna';
          _username = 'user';
          _email = '-';
          _noTelp = '-';
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _nama = 'Pengguna';
        _username = 'user';
        _email = '-';
        _noTelp = '-';
        _isLoadingProfile = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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

      await _loadProfileFromApi();

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

  Future<void> _logout(BuildContext context) async {
    if (_isLoggingOut) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          'Logout?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: kTextColor,
          ),
        ),
        content: const Text(
          'Kamu yakin ingin keluar dari akun ini?',
          style: TextStyle(
            fontSize: 13,
            color: kHintColor,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Batal',
              style: TextStyle(
                color: kHintColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      await ApiService.logout();
    } catch (_) {
      await SessionService.clearToken();
    }

    await SessionService.clearToken();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  Widget _buildAvatar() {
    Widget image;

    if (_fotoFile != null) {
      image = Image.file(_fotoFile!, fit: BoxFit.cover);
    } else if (_fotoUrl != null && _fotoUrl!.isNotEmpty) {
      image = Image.network(
        _fotoUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.person,
          size: 50,
          color: kHintColor,
        ),
      );
    } else {
      image = Container(
        color: const Color(0xFFE8F5F0),
        child: const Icon(
          Icons.person_rounded,
          color: kPrimaryGreen,
          size: 50,
        ),
      );
    }

    return Stack(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: kPrimaryGreen,
              width: 2.5,
            ),
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
            child: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    if (_isLoadingProfile) {
      return const Column(
        children: [
          SizedBox(height: 20),
          CircularProgressIndicator(
            color: kPrimaryGreen,
          ),
          SizedBox(height: 20),
          Text(
            'Memuat profil...',
            style: TextStyle(
              fontSize: 13,
              color: kHintColor,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () => _bukaEditProfil(context),
          child: _buildAvatar(),
        ),
        const SizedBox(height: 14),
        Text(
          _nama,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: kTextColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '@$_username',
          style: const TextStyle(
            fontSize: 14,
            color: kHintColor,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.mail_outline,
              size: 16,
              color: kHintColor,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                _email,
                style: const TextStyle(
                  fontSize: 13,
                  color: kHintColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.phone_outlined,
              size: 16,
              color: kHintColor,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                _noTelp,
                style: const TextStyle(
                  fontSize: 13,
                  color: kHintColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWishlist() {
    return Column(
      children: [
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
                            errorBuilder: (_, __, ___) => Container(
                              height: 85,
                              color: kInputBg,
                              child: const Icon(
                                Icons.image,
                                color: kHintColor,
                              ),
                            ),
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
      ],
    );
  }

  Widget _buildMenu() {
    final menuItems = [
  {
    'icon': Icons.person_outline,
    'label': 'Edit Profil',
    'type': 'edit',
    'isLast': false,
  },
  if (_role == 'admin')
    {
      'icon': Icons.qr_code_scanner,
      'label': 'Scan Tiket',
      'type': 'scan',
      'isLast': false,
    },
  {
    'icon': Icons.lock_outline,
    'label': 'Ganti Password',
    'type': 'password',
    'isLast': false,
  },
  {
    'icon': Icons.logout,
    'label': 'Log out',
    'type': 'logout',
    'isLast': true,
  },
];

    return Container(
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
                trailing: _isLoggingOut && isLast
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.red,
                        ),
                      )
                    : const Icon(
                        Icons.chevron_right,
                        color: kHintColor,
                        size: 20,
                      ),
                onTap: () {
                  final type = item['type']?.toString();

                  if (type == 'edit') {
                    _bukaEditProfil(context);
                  } else if (type == 'scan') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminScanScreen(),
                      ),
                    );
                  } else if (type == 'password') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordScreen(),
                      ),
                    );
                  } else if (type == 'logout') {
                    _logout(context);
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
    );
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            onPressed: _loadProfileFromApi,
            icon: const Icon(
              Icons.refresh,
              color: kPrimaryGreen,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: kPrimaryGreen,
        onRefresh: _loadProfileFromApi,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 28),
              _buildWishlist(),
              const SizedBox(height: 24),
              _buildMenu(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
