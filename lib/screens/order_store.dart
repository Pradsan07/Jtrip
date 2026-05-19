import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// MODEL PESANAN
// ─────────────────────────────────────────────

class OrderModel {
  final String id;
  final String namaWisata;
  final String imageUrl;
  final DateTime tanggalKunjungan;
  final int jumlahTiket;
  final int totalBayar;
  final String status; // 'Terjadwal' | 'Selesai'
  final DateTime tanggalPesan;

  OrderModel({
    required this.id,
    required this.namaWisata,
    required this.imageUrl,
    required this.tanggalKunjungan,
    required this.jumlahTiket,
    required this.totalBayar,
    required this.status,
    required this.tanggalPesan,
  });

  String get formattedTanggalKunjungan {
    const bulan = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${tanggalKunjungan.day} ${bulan[tanggalKunjungan.month]} ${tanggalKunjungan.year}';
  }

  String get formattedTotal {
    final s = totalBayar.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return 'Rp $s';
  }
}

// ─────────────────────────────────────────────
// ORDER STORE — ValueNotifier (tanpa package tambahan)
// ─────────────────────────────────────────────

class OrderStore extends ValueNotifier<List<OrderModel>> {
  OrderStore() : super([]);

  // Tambah pesanan baru
  void addOrder(OrderModel order) {
    value = [...value, order];
  }

  // Generate ID unik
  static String generateId() {
    final now = DateTime.now();
    return 'JMR-${now.millisecondsSinceEpoch.toString().substring(7)}';
  }
}

// Singleton global agar bisa diakses dari mana saja
final orderStore = OrderStore();

// ─────────────────────────────────────────────
// INHERITED WIDGET — agar widget tree bisa listen
// ─────────────────────────────────────────────

class OrderStoreProvider extends InheritedNotifier<OrderStore> {
  const OrderStoreProvider({
    super.key,
    required super.child,
    required OrderStore store,
  }) : super(notifier: store);

  static OrderStore of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<OrderStoreProvider>();
    assert(provider != null, 'OrderStoreProvider tidak ditemukan di widget tree');
    return provider!.notifier!;
  }
}
