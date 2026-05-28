import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:jtrip/services/api_service.dart';

const kPrimaryGreen = Color(0xFF2D6A4F);
const kBgGray = Color(0xFFF5F5F5);
const kInputBg = Color(0xFFEAEAEA);
const kHintColor = Color(0xFFAAAAAA);
const kTextColor = Color(0xFF1A1A1A);

class AdminScanScreen extends StatefulWidget {
  const AdminScanScreen({super.key});

  @override
  State<AdminScanScreen> createState() => _AdminScanScreenState();
}

class _AdminScanScreenState extends State<AdminScanScreen> {
  final MobileScannerController _scannerController = MobileScannerController();

  bool _isScanning = true;
  bool _isLoading = false;
  bool _isMarkingUsed = false;

  Map<String, dynamic>? _ticketData;
  String? _lastQrData;

  @override
  void dispose() {
    _scannerController.dispose();
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

  Future<void> _handleQr(String qrData) async {
    if (!_isScanning || _isLoading) return;

    setState(() {
      _isScanning = false;
      _isLoading = true;
      _lastQrData = qrData;
    });

    try {
      await _scannerController.stop();

      final result = await ApiService.scanAdminTiket(qrData: qrData);
      final data = result['data'];

      if (data is! Map<String, dynamic>) {
        throw Exception('Data tiket tidak valid dari server.');
      }

      if (!mounted) return;

      setState(() {
        _ticketData = data;
      });

      _showSnack(result['message']?.toString() ?? 'Tiket ditemukan.');
    } on ApiException catch (e) {
      _showSnack(e.message, isError: true);

      if (mounted) {
        setState(() {
          _ticketData = null;
        });
      }
    } catch (e) {
      _showSnack(
        e.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );

      if (mounted) {
        setState(() {
          _ticketData = null;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _scanAgain() async {
    setState(() {
      _ticketData = null;
      _lastQrData = null;
      _isScanning = true;
    });

    await _scannerController.start();
  }

  Future<void> _markAsUsed() async {
    final data = _ticketData;
    if (data == null) return;

    final idTiket = data['id_tiket']?.toString();

    if (idTiket == null || idTiket.isEmpty) {
      _showSnack('ID tiket tidak ditemukan.', isError: true);
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Gunakan tiket?'),
        content: const Text(
          'Setelah dikonfirmasi, status tiket akan berubah menjadi used dan tidak bisa digunakan ulang.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Gunakan'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isMarkingUsed = true;
    });

    try {
      final result = await ApiService.markTiketAsUsed(idTiket: idTiket);
      final updatedData = result['data'];

      if (!mounted) return;

      setState(() {
        if (updatedData is Map<String, dynamic>) {
          _ticketData = {
            ...data,
            ...updatedData,
            'status': updatedData['status'] ?? 'used',
          };
        } else {
          _ticketData = {
            ...data,
            'status': 'used',
          };
        }
      });

      _showSnack(result['message']?.toString() ?? 'Tiket berhasil digunakan.');
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
          _isMarkingUsed = false;
        });
      }
    }
  }

  String _getNestedText(Map<String, dynamic>? map, String key, String fallback) {
    if (map == null) return fallback;

    final value = map[key];

    if (value == null || value.toString().trim().isEmpty) {
      return fallback;
    }

    return value.toString();
  }

  int _getInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? '0') ?? 0;
  }

  String _formatPrice(int value) {
    final s = value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );

    return 'Rp $s';
  }

  Color _statusColor(String status) {
    final lower = status.toLowerCase();

    if (lower == 'paid') return kPrimaryGreen;
    if (lower == 'used') return Colors.grey;
    if (lower == 'pending') return const Color(0xFFE08C00);

    return Colors.red;
  }

  Color _statusBg(String status) {
    final lower = status.toLowerCase();

    if (lower == 'paid') return const Color(0xFFE8F5F0);
    if (lower == 'used') return const Color(0xFFEDEDED);
    if (lower == 'pending') return const Color(0xFFFFF8E1);

    return const Color(0xFFFFEBEE);
  }

  Widget _buildScanner() {
    return Column(
      children: [
        Container(
          height: 310,
          margin: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              MobileScanner(
                controller: _scannerController,
                onDetect: (capture) {
                  final barcodes = capture.barcodes;

                  if (barcodes.isEmpty) return;

                  final value = barcodes.first.rawValue;

                  if (value == null || value.trim().isEmpty) return;

                  _handleQr(value.trim());
                },
              ),
              Center(
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              ),
              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.55),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Text(
            'Arahkan kamera ke QR e-ticket pengunjung untuk melihat detail tiket.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kHintColor,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTicketDetail() {
    final data = _ticketData!;
    final user = data['user'] is Map<String, dynamic>
        ? data['user'] as Map<String, dynamic>
        : <String, dynamic>{};

    final wisata = data['wisata'] is Map<String, dynamic>
        ? data['wisata'] as Map<String, dynamic>
        : <String, dynamic>{};

    final transaksi = data['transaksi'] is Map<String, dynamic>
        ? data['transaksi'] as Map<String, dynamic>
        : <String, dynamic>{};

    final status = data['status']?.toString() ?? '-';
    final statusPembayaran =
        transaksi['status_pembayaran']?.toString() ?? '-';

    final jumlahPengunjung = _getInt(data['jumlah_pengunjung']);
    final grandTotal = _getInt(data['grand_total']);

    final canUse =
        status.toLowerCase() == 'paid' && statusPembayaran.toLowerCase() == 'paid';

    final alreadyUsed = status.toLowerCase() == 'used';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      child: Column(
        children: [
          Container(
            width: double.infinity,
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
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: _statusBg(status),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    alreadyUsed
                        ? Icons.verified_outlined
                        : canUse
                            ? Icons.confirmation_number_outlined
                            : Icons.warning_amber_rounded,
                    color: _statusColor(status),
                    size: 34,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  data['kode_booking']?.toString() ?? '-',
                  style: const TextStyle(
                    color: kTextColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusBg(status),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: _statusColor(status),
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _DetailRow(
                  label: 'Nama Pengunjung',
                  value: _getNestedText(user, 'name', '-'),
                  icon: Icons.person_outline,
                ),
                _DetailRow(
                  label: 'Email',
                  value: _getNestedText(user, 'email', '-'),
                  icon: Icons.mail_outline,
                ),
                _DetailRow(
                  label: 'Wisata',
                  value: _getNestedText(wisata, 'name', '-'),
                  icon: Icons.place_outlined,
                ),
                _DetailRow(
                  label: 'Lokasi',
                  value: _getNestedText(wisata, 'lokasi', '-'),
                  icon: Icons.location_on_outlined,
                ),
                _DetailRow(
                  label: 'Tanggal Kunjungan',
                  value: data['tanggal_kunjungan']?.toString() ?? '-',
                  icon: Icons.calendar_month_outlined,
                ),
                _DetailRow(
                  label: 'Jumlah Pengunjung',
                  value: '$jumlahPengunjung orang',
                  icon: Icons.groups_outlined,
                ),
                _DetailRow(
                  label: 'Total Pembayaran',
                  value: _formatPrice(grandTotal),
                  icon: Icons.payments_outlined,
                ),
                _DetailRow(
                  label: 'Status Pembayaran',
                  value: statusPembayaran.toUpperCase(),
                  icon: Icons.wallet_outlined,
                ),
                const SizedBox(height: 18),
                if (_lastQrData != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: kBgGray,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'QR: $_lastQrData',
                      style: const TextStyle(
                        color: kHintColor,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (alreadyUsed)
            _InfoBox(
              message: 'Tiket ini sudah digunakan sebelumnya.',
              color: Colors.grey,
              icon: Icons.info_outline,
            )
          else if (!canUse)
            _InfoBox(
              message:
                  'Tiket belum valid untuk digunakan. Pastikan status tiket dan pembayaran sudah paid.',
              color: Colors.red,
              icon: Icons.warning_amber_rounded,
            )
          else
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isMarkingUsed ? null : _markAsUsed,
                icon: _isMarkingUsed
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.3,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(
                  _isMarkingUsed ? 'Memproses...' : 'Gunakan Tiket',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: _scanAgain,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text(
                'Scan Tiket Lain',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasTicket = _ticketData != null;

    return Scaffold(
      backgroundColor: kBgGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Scan Tiket',
          style: TextStyle(
            color: kPrimaryGreen,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: kTextColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: hasTicket ? _buildTicketDetail() : _buildScanner(),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 19,
            color: kPrimaryGreen,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: kHintColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: kTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.35,
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

class _InfoBox extends StatelessWidget {
  final String message;
  final Color color;
  final IconData icon;

  const _InfoBox({
    required this.message,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.25),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}