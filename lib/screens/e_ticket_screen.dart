import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

const kPrimaryGreen = Color(0xFF2D6A4F);
const kBgGray = Color(0xFFF5F5F5);
const kInputBg = Color(0xFFEAEAEA);
const kHintColor = Color(0xFFAAAAAA);
const kTextColor = Color(0xFF1A1A1A);

class ETicketScreen extends StatelessWidget {
  final String kodeBooking;
  final String namaWisata;
  final String? imageUrl;
  final String tanggalKunjungan;
  final int jumlahPengunjung;
  final int grandTotal;
  final String status;
  final List<dynamic> detailTiket;

  const ETicketScreen({
    super.key,
    required this.kodeBooking,
    required this.namaWisata,
    required this.imageUrl,
    required this.tanggalKunjungan,
    required this.jumlahPengunjung,
    required this.grandTotal,
    required this.status,
    required this.detailTiket,
  });

  String _formatPrice(int value) {
    final s = value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );

    return 'Rp $s';
  }

  String get _statusLabel {
    final lower = status.toLowerCase();

    if (lower == 'paid') return 'Paid';
    if (lower == 'used') return 'Used';
    if (lower == 'pending') return 'Pending';

    return status;
  }

  Color get _statusColor {
    final lower = status.toLowerCase();

    if (lower == 'paid') return kPrimaryGreen;
    if (lower == 'used') return Colors.grey;
    if (lower == 'pending') return const Color(0xFFE08C00);

    return kPrimaryGreen;
  }

  Color get _statusBg {
    final lower = status.toLowerCase();

    if (lower == 'paid') return const Color(0xFFE8F5F0);
    if (lower == 'used') return const Color(0xFFEDEDED);
    if (lower == 'pending') return const Color(0xFFFFF8E1);

    return const Color(0xFFE8F5F0);
  }

  String _ticketCodeFromItem(dynamic item, int index) {
    if (item is Map) {
      return item['kode_tiket']?.toString() ??
          item['kode_qr']?.toString() ??
          item['kode']?.toString() ??
          '$kodeBooking-${index + 1}';
    }

    return '$kodeBooking-${index + 1}';
  }

  String _ticketNameFromItem(dynamic item, int index) {
    if (item is Map) {
      return item['nama_pengunjung']?.toString() ??
          item['nama']?.toString() ??
          'Pengunjung ${index + 1}';
    }

    return 'Pengunjung ${index + 1}';
  }

  Future<void> _copyKode(BuildContext context) async {
    await Clipboard.setData(
      ClipboardData(text: kodeBooking),
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kode booking berhasil disalin.'),
        backgroundColor: kPrimaryGreen,
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      height: 180,
      width: double.infinity,
      color: kInputBg,
      child: const Icon(
        Icons.confirmation_number_outlined,
        color: kHintColor,
        size: 48,
      ),
    );
  }

  Widget _buildHeaderImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _imageFallback();
    }

    return Image.network(
      imageUrl!,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _imageFallback(),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 18,
            color: kPrimaryGreen,
          ),
          const SizedBox(width: 10),
        ],
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
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTicketList() {
    final count = detailTiket.isNotEmpty ? detailTiket.length : jumlahPengunjung;

    return Column(
      children: List.generate(count, (index) {
        final item = detailTiket.isNotEmpty ? detailTiket[index] : null;
        final ticketCode = _ticketCodeFromItem(item, index);
        final ticketName = _ticketNameFromItem(item, index);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: kBgGray,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5F0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: kPrimaryGreen,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticketName,
                      style: const TextStyle(
                        color: kTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      ticketCode,
                      style: const TextStyle(
                        color: kHintColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.verified_outlined,
                color: kPrimaryGreen,
                size: 22,
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final qrData = 'JTRIP|$kodeBooking|$namaWisata|$tanggalKunjungan|$jumlahPengunjung';

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
          'E-Tiket',
          style: TextStyle(
            color: kPrimaryGreen,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Stack(
                    children: [
                      _buildHeaderImage(),
                      Positioned(
                        top: 14,
                        right: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _statusBg,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            _statusLabel,
                            style: TextStyle(
                              color: _statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          namaWisata,
                          style: const TextStyle(
                            color: kTextColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                kodeBooking,
                                style: const TextStyle(
                                  color: kHintColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _copyKode(context),
                              icon: const Icon(
                                Icons.copy,
                                size: 15,
                              ),
                              label: const Text('Salin'),
                              style: TextButton.styleFrom(
                                foregroundColor: kPrimaryGreen,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                              ),
                            ),
                            child: QrImageView(
                              data: qrData,
                              version: QrVersions.auto,
                              size: 190,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Center(
                          child: Text(
                            'Tunjukkan QR ini kepada petugas loket',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: kHintColor,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: kBgGray,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow(
                                label: 'Tanggal Kunjungan',
                                value: tanggalKunjungan,
                                icon: Icons.calendar_month_outlined,
                              ),
                              const SizedBox(height: 14),
                              _buildInfoRow(
                                label: 'Jumlah Pengunjung',
                                value: '$jumlahPengunjung orang',
                                icon: Icons.groups_outlined,
                              ),
                              const SizedBox(height: 14),
                              _buildInfoRow(
                                label: 'Total Pembayaran',
                                value: _formatPrice(grandTotal),
                                icon: Icons.payments_outlined,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detail Tiket',
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTicketList(),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFFFECB3),
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Color(0xFFE08C00),
                    size: 22,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'E-tiket hanya berlaku pada tanggal kunjungan yang tertera. Pastikan QR Code terlihat jelas saat ditunjukkan kepada petugas.',
                      style: TextStyle(
                        color: Color(0xFF7A5200),
                        fontSize: 12,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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