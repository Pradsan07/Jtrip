import 'package:flutter/material.dart';
import 'order_store.dart';

const kPrimaryGreen = Color(0xFF2D6A4F);
const kBgGray = Color(0xFFF5F5F5);
const kInputBg = Color(0xFFEAEAEA);
const kHintColor = Color(0xFFAAAAAA);
const kTextColor = Color(0xFF1A1A1A);

// ─────────────────────────────────────────────
// HELPER — FORMAT TANGGAL & HARI
// ─────────────────────────────────────────────

const List<String> _namaHari = [
  'MIN',
  'SEN',
  'SEL',
  'RAB',
  'KAM',
  'JUM',
  'SAB',
];

const List<String> _namaBulan = [
  '',
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

const List<String> _namaHariPanjang = [
  'Minggu',
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
];

String formatTanggalLengkap(DateTime date) {
  // Contoh: "Rabu, 15 Mei 2026"
  return '${_namaHariPanjang[date.weekday % 7]}, ${date.day} ${_namaBulan[date.month]} ${date.year}';
}

String formatBulanTahun(DateTime date) {
  // Contoh: "Mei 2026"
  return '${_namaBulan[date.month]} ${date.year}';
}

// Generate 5 hari mulai hari ini
List<DateTime> generateDays() {
  final today = DateTime.now();
  return List.generate(5, (i) => today.add(Duration(days: i)));
}

// ─────────────────────────────────────────────
// BOOKING SCREEN — Pilih Waktu
// ─────────────────────────────────────────────

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedDayIndex = 0; // default hari ini
  int _ticketCount = 2;

  // List 5 hari mulai hari ini
  final List<DateTime> _days = generateDays();

  DateTime get _selectedDate => _days[_selectedDayIndex];
  int get _totalPrice => _ticketCount * 25000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pilih Waktu',
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Destination card ──
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200',
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 70,
                              height: 70,
                              color: kInputBg,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'WISATA ALAM',
                              style: TextStyle(
                                fontSize: 10,
                                color: kHintColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Pantai Papuma',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: kTextColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: const [
                                Icon(Icons.star, color: Colors.amber, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  '4.8 (2.4k ulasan)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kHintColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Pilih Tanggal ──
                  const Text(
                    'Pilih Tanggal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: kTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Sesuaikan dengan jadwal perjalananmu',
                    style: TextStyle(fontSize: 12, color: kHintColor),
                  ),
                  const SizedBox(height: 12),

                  // Bulan & Tahun — update otomatis sesuai hari dipilih
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      formatBulanTahun(_selectedDate),
                      style: const TextStyle(
                        color: kPrimaryGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Day selector — generated dari DateTime.now() ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_days.length, (index) {
                      final day = _days[index];
                      final isSelected = _selectedDayIndex == index;
                      final isToday = index == 0;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedDayIndex = index),
                        child: Container(
                          width: 58,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? kPrimaryGreen : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? kPrimaryGreen
                                  : const Color(0xFFEEEEEE),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                isToday
                                    ? 'HARI\nINI'
                                    : _namaHari[day.weekday % 7],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white70
                                      : kHintColor,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${day.day}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? Colors.white : kTextColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (isSelected)
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  // ── Jam Buka ──
                  const _InfoRow(title: 'Jam Buka', value: '24 Jam'),
                  const Divider(height: 1),

                  // ── Jumlah Tiket ──
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jumlah Tiket',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: kTextColor,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Maksimal 5 per transaksi',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: kHintColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_ticketCount > 1) {
                                  setState(() => _ticketCount--);
                                }
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(color: kInputBg),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.remove,
                                  size: 16,
                                  color: kTextColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: Text(
                                '$_ticketCount',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: kTextColor,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_ticketCount < 5) {
                                  setState(() => _ticketCount++);
                                }
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: kPrimaryGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // ── Lokasi ──
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lokasi',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: kTextColor,
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: kPrimaryGreen,
                            ),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Desa Lojejer, Kecamatan Wuluhan, Kabupaten Jember, Jawa Timur',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: kHintColor,
                                  height: 1.4,
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
            ),
          ),

          // ── Bottom bar ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Estimasi Biaya',
                      style: TextStyle(fontSize: 12, color: kHintColor),
                    ),
                    Text(
                      'Rp ${_formatPrice(_totalPrice)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: kTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CheckoutScreen(
                              ticketCount: _ticketCount,
                              selectedDate: _selectedDate,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Lanjutkan',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
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

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: kTextColor,
            ),
          ),
          Text(value, style: const TextStyle(fontSize: 14, color: kHintColor)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CHECKOUT SCREEN
// ─────────────────────────────────────────────

class CheckoutScreen extends StatefulWidget {
  final int ticketCount;
  final DateTime selectedDate; // ← terima DateTime langsung

  const CheckoutScreen({
    super.key,
    required this.ticketCount,
    required this.selectedDate,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPayment = 0;

  final List<Map<String, String>> _paymentMethods = [
    {'label': 'QRIS', 'name': 'QRIS / E-Wallet'},
    {'label': 'BCA', 'name': 'BCA Virtual Account'},
    {'label': 'MANDIRI', 'name': 'Mandiri Bill Payment'},
    {'label': '💳', 'name': 'Kartu Kredit/Debit'},
  ];

  int get _subtotal => widget.ticketCount * 25000;
  int get _serviceFee => 2500;
  int get _total => _subtotal + _serviceFee;

  // Format jam sesuai jam buka wisata
  String get _jamKunjungan => '08.00 - 10.00 WIB';

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
          'Checkout Tiket',
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Detail Pesanan ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Detail Pesanan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: kTextColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Ubah',
                          style: TextStyle(
                            color: kPrimaryGreen,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(height: 140, color: kInputBg),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Pantai Papuma',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: kTextColor,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Tanggal — dari DateTime yang dipilih user
                        _DetailRow(
                          icon: Icons.calendar_month_outlined,
                          text: formatTanggalLengkap(widget.selectedDate),
                        ),
                        const SizedBox(height: 8),

                        // Jam kunjungan
                        _DetailRow(
                          icon: Icons.access_time,
                          text: _jamKunjungan,
                        ),
                        const SizedBox(height: 8),

                        // Jumlah tiket
                        _DetailRow(
                          icon: Icons.confirmation_number_outlined,
                          text: '${widget.ticketCount} Tiket Dewasa',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Metode Pembayaran ──
                  const Text(
                    'Metode Pembayaran',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: kTextColor,
                    ),
                  ),
                  const SizedBox(height: 14),

                  ...List.generate(_paymentMethods.length, (index) {
                    final isSelected = _selectedPayment == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedPayment = index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? kPrimaryGreen
                                : const Color(0xFFEEEEEE),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 46,
                              height: 30,
                              decoration: BoxDecoration(
                                color: kBgGray,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  _paymentMethods[index]['label']!,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: kTextColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _paymentMethods[index]['name']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: kTextColor,
                                ),
                              ),
                            ),
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: isSelected ? kPrimaryGreen : kHintColor,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),

                  // ── Ringkasan Biaya ──
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F0E8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _SummaryRow(
                          label: 'Subtotal(${widget.ticketCount} Tiket)',
                          value: 'Rp ${_formatPrice(_subtotal)}',
                          isTotal: false,
                        ),
                        const SizedBox(height: 8),
                        _SummaryRow(
                          label: 'Bayar Layanan',
                          value: 'Rp ${_formatPrice(_serviceFee)}',
                          isTotal: false,
                        ),
                        const Divider(height: 20),
                        _SummaryRow(
                          label: 'Total Bayar',
                          value: 'Rp${_formatPrice(_total)}',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: const [
                      Icon(
                        Icons.verified_user_outlined,
                        color: kPrimaryGreen,
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Pembayaran Aman & Terenkripsi',
                        style: TextStyle(fontSize: 12, color: kHintColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── Bayar Sekarang ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Tentukan status: Terjadwal jika tanggal >= hari ini
                  final now = DateTime.now();
                  final isToday =
                      widget.selectedDate.year == now.year &&
                      widget.selectedDate.month == now.month &&
                      widget.selectedDate.day == now.day;
                  final isFuture = widget.selectedDate.isAfter(now);
                  final status = (isToday || isFuture)
                      ? 'Terjadwal'
                      : 'Selesai';

                  // Buat ID unik & simpan ke OrderStore
                  final orderId = OrderStore.generateId();
                  orderStore.addOrder(
                    OrderModel(
                      id: orderId,
                      namaWisata: 'Pantai Papuma',
                      imageUrl:
                          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
                      tanggalKunjungan: widget.selectedDate,
                      jumlahTiket: widget.ticketCount,
                      totalBayar: _total,
                      status: status,
                      tanggalPesan: DateTime.now(),
                    ),
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DigitalTicketScreen(
                        selectedDate: widget.selectedDate,
                        orderId: orderId,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.wallet, size: 20),
                label: const Text(
                  'Bayar Sekarang',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 0,
                ),
              ),
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: kHintColor),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13, color: kHintColor)),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.isTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 14 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.normal,
            color: isTotal ? kTextColor : kHintColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.normal,
            color: isTotal ? kPrimaryGreen : kHintColor,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// DIGITAL TICKET SCREEN
// ─────────────────────────────────────────────

class DigitalTicketScreen extends StatelessWidget {
  final DateTime selectedDate;
  final String orderId;

  const DigitalTicketScreen({
    super.key,
    required this.selectedDate,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tiket Digital',
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
            // Hero image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(height: 200, color: kInputBg),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'WISATA ALAM',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: kPrimaryGreen,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Pantai Papuma',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tanggal kunjungan di tiket — dari date yang dipilih user
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: kPrimaryGreen,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    formatTanggalLengkap(selectedDate),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryGreen,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Status & ID
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'STATUS TIKET',
                        style: TextStyle(
                          fontSize: 11,
                          color: kHintColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5F0),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: kPrimaryGreen.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.circle, color: kPrimaryGreen, size: 8),
                            SizedBox(width: 6),
                            Text(
                              'Aktif',
                              style: TextStyle(
                                color: kPrimaryGreen,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'ID TRANSAKSI',
                      style: TextStyle(
                        fontSize: 11,
                        color: kHintColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '#$orderId',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: kTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),

            // QR Code area
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: kBgGray,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFDDDDDD), width: 1.5),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.network(
                      'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=JMR-882910',
                      width: 150,
                      height: 150,
                      errorBuilder: (_, __, ___) => Container(
                        width: 150,
                        height: 150,
                        color: kInputBg,
                        child: const Icon(
                          Icons.qr_code_2,
                          size: 80,
                          color: kHintColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tunjukkan QR Code ini kepada petugas di\npintu masuk lokasi wisata.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: kHintColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Center(
              child: Icon(
                Icons.confirmation_number_outlined,
                color: kHintColor.withOpacity(0.4),
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
