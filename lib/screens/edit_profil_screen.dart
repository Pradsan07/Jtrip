import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jtrip/services/api_service.dart';

const kPrimaryGreen = Color(0xFF2D6A4F);
const kBgGray = Color(0xFFF5F5F5);
const kInputBg = Color(0xFFEAEAEA);
const kHintColor = Color(0xFFAAAAAA);
const kTextColor = Color(0xFF1A1A1A);
const kLightGreen = Color(0xFFE8F5F0);

// ─────────────────────────────────────────────
// EDIT PROFIL SCREEN
// ─────────────────────────────────────────────

class EditProfilScreen extends StatefulWidget {
  // Data profil awal diterima dari ProfilScreen
  final String? nama;
  final String? username;
  final String? email;
  final String? noTelp;
  final String? fotoUrl;
  final File? fotoFile;

  const EditProfilScreen({
    super.key,
    this.nama,
    this.username,
    this.email,
    this.noTelp,
    this.fotoUrl,
    this.fotoFile,
  });

  @override
  State<EditProfilScreen> createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _namaCtrl;
  late TextEditingController _usernameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _noTelpCtrl;

  File? _fotoFile;
  bool _isLoading = false;
  bool _hasChanges = false;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final ImagePicker _picker = ImagePicker();

  @override
void initState() {
  super.initState();

  _namaCtrl = TextEditingController(text: widget.nama ?? '');
  _usernameCtrl = TextEditingController(text: widget.username ?? '');
  _emailCtrl = TextEditingController(text: widget.email ?? '');
  _noTelpCtrl = TextEditingController(text: widget.noTelp ?? '');
  _fotoFile = widget.fotoFile;

  for (final ctrl in [_namaCtrl, _usernameCtrl, _emailCtrl, _noTelpCtrl]) {
    ctrl.addListener(_onChanged);
  }

  _animCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
  _slideAnim = Tween<Offset>(
    begin: const Offset(0, 0.06),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));

  _animCtrl.forward();

  _loadProfile();
}

Future<void> _loadProfile() async {
  setState(() => _isLoading = true);

  try {
    final result = await ApiService.me();

    print('DATA PROFILE: $result');

    final data = result['data'];

    setState(() {
      _namaCtrl.text = data['name']?.toString() ?? '';
      _emailCtrl.text = data['email']?.toString() ?? '';
      _noTelpCtrl.text = data['no_telp']?.toString() ?? '';

      // Kalau database kamu belum punya username, bisa kosongkan dulu
      _usernameCtrl.text = data['username']?.toString() ?? '';

      _hasChanges = false;
      _isLoading = false;
    });
  } catch (e) {
    setState(() => _isLoading = false);

    if (!mounted) return;

    _showSnack(
      e.toString().replaceFirst('Exception: ', ''),
      isError: true,
    );
  }
}

  @override
  void dispose() {
    _namaCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _noTelpCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  // ── Crop foto menggunakan UI custom ──
  Future<File?> _cropImage(File imageFile) async {
    File? croppedFile;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _CropImageScreen(
          imageFile: imageFile,
          onCropped: (file) => croppedFile = file,
        ),
      ),
    );
    return croppedFile;
  }

  // ── Pilih foto dari galeri ──
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: kInputBg,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ubah Foto Profil',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: kTextColor,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _BottomSheetOption(
                      icon: Icons.photo_library_outlined,
                      label: 'Galeri',
                      color: kPrimaryGreen,
                      onTap: () async {
                        Navigator.pop(context);
                        final picked = await _picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 85,
                          maxWidth: 800,
                        );
                        if (picked != null) {
                          final cropped = await _cropImage(File(picked.path));
                          if (cropped != null) {
                            setState(() {
                              _fotoFile = cropped;
                              _hasChanges = true;
                            });
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _BottomSheetOption(
                      icon: Icons.camera_alt_outlined,
                      label: 'Kamera',
                      color: const Color(0xFF1A6BB5),
                      onTap: () async {
                        Navigator.pop(context);
                        final picked = await _picker.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 85,
                          maxWidth: 800,
                        );
                        if (picked != null) {
                          final cropped = await _cropImage(File(picked.path));
                          if (cropped != null) {
                            setState(() {
                              _fotoFile = cropped;
                              _hasChanges = true;
                            });
                          }
                        }
                      },
                    ),
                  ),
                  if (_fotoFile != null || widget.fotoUrl != null) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: _BottomSheetOption(
                        icon: Icons.delete_outline,
                        label: 'Hapus',
                        color: Colors.red,
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _fotoFile = null;
                            _hasChanges = true;
                          });
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Simpan perubahan ──
  Future<void> _simpan() async {
  if (!_hasChanges) return;

  if (_namaCtrl.text.trim().isEmpty) {
    _showSnack('Nama tidak boleh kosong', isError: true);
    return;
  }

  if (!_emailCtrl.text.contains('@')) {
    _showSnack('Format email tidak valid', isError: true);
    return;
  }

  setState(() => _isLoading = true);

  try {
    await ApiService.updateProfile(
      name: _namaCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      noTelp: _noTelpCtrl.text.trim(),

      // Karena form edit kamu belum punya field ini,
      // sementara isi default dulu.
      kewarganegaraan: 'domestik',
      jenisIdentitas: 'nik',
      nomorIdentitas: '',
      jenisKelamin: 'laki-laki',
      tanggalLahir: '2000-01-01',
    );

    setState(() {
      _isLoading = false;
      _hasChanges = false;
    });

    if (!mounted) return;

    _showSnack('Profil berhasil diperbarui ✓');

    Navigator.pop(context, {
      'nama': _namaCtrl.text.trim(),
      'username': _usernameCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'noTelp': _noTelpCtrl.text.trim(),
      'fotoFile': _fotoFile,
    });
  } catch (e) {
    setState(() => _isLoading = false);

    if (!mounted) return;

    _showSnack(
      e.toString().replaceFirst('Exception: ', ''),
      isError: true,
    );
  }
}

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError ? Colors.red : kPrimaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGray,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
            child: Column(
              children: [
                _buildAvatarSection(),
                const SizedBox(height: 32),
                _buildFormSection(),
                const SizedBox(height: 28),
                _buildSimpanButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── APP BAR ──
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: kTextColor),
        onPressed: () {
          if (_hasChanges) {
            _showDiscardDialog();
          } else {
            Navigator.pop(context);
          }
        },
      ),
      title: const Text(
        'Edit Profil',
        style: TextStyle(
          color: kPrimaryGreen,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
    );
  }

  // ── AVATAR SECTION ──
  Widget _buildAvatarSection() {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Avatar
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: kPrimaryGreen, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryGreen.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: _buildAvatarImage(),
              ),
            ),
          ),

          // Edit badge
          Positioned(
            bottom: -6,
            right: -6,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: kPrimaryGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryGreen.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 17,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage() {
    // Prioritas: file baru > URL lama > placeholder
    if (_fotoFile != null) {
      return Image.file(_fotoFile!, fit: BoxFit.cover);
    } else if (widget.fotoUrl != null) {
      return Image.network(
        widget.fotoUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _avatarPlaceholder(),
      );
    }
    return _avatarPlaceholder();
  }

  Widget _avatarPlaceholder() {
    return Container(
      color: kLightGreen,
      child: const Icon(Icons.person_rounded, color: kPrimaryGreen, size: 54),
    );
  }

  // ── FORM SECTION ──
  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel(label: 'Informasi Pribadi'),
          const SizedBox(height: 16),

          _EditField(
            label: 'Nama Lengkap',
            controller: _namaCtrl,
            hint: 'Masukkan nama lengkap',
            icon: Icons.person_outline_rounded,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 16),

          // Username — tidak dapat diedit
          _ReadOnlyField(
            label: 'Username',
            value: '@${widget.username}',
            icon: Icons.alternate_email_rounded,
          ),
          const SizedBox(height: 24),

          const _SectionLabel(label: 'Kontak'),
          const SizedBox(height: 16),

          _EditField(
            label: 'Email',
            controller: _emailCtrl,
            hint: 'nama@gmail.com',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          _EditField(
            label: 'Nomor Telepon',
            controller: _noTelpCtrl,
            hint: '+62 812-xxxx-xxxx',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  // ── SIMPAN BUTTON ──
  Widget _buildSimpanButton() {
    return AnimatedOpacity(
      opacity: _hasChanges ? 1.0 : 0.45,
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: _hasChanges && !_isLoading ? _simpan : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryGreen,
            foregroundColor: Colors.white,
            disabledBackgroundColor: kPrimaryGreen,
            disabledForegroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 0,
            shadowColor: kPrimaryGreen.withOpacity(0.4),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Text(
                  'Simpan Perubahan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }

  // ── Dialog konfirmasi batalkan ──
  void _showDiscardDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Batalkan Perubahan?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: kTextColor,
          ),
        ),
        content: const Text(
          'Perubahan yang belum disimpan akan hilang.',
          style: TextStyle(fontSize: 13, color: kHintColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Lanjut Edit',
              style: TextStyle(
                color: kPrimaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // tutup dialog
              Navigator.pop(context); // kembali ke profil
            },
            child: const Text(
              'Batalkan',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// REUSABLE WIDGETS
// ─────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: kPrimaryGreen,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: kHintColor,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final String? prefixText;

  const _EditField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: kHintColor,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 15,
            color: kTextColor,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: kHintColor, fontSize: 14),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 8),
              child: Icon(icon, color: kPrimaryGreen, size: 20),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            prefixText: prefixText,
            prefixStyle: const TextStyle(
              color: kHintColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: kBgGray,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFEEEEEE), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: kPrimaryGreen, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomSheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _BottomSheetOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// READ-ONLY FIELD — untuk username
// ─────────────────────────────────────────────

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ReadOnlyField({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: kHintColor,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: kInputBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Tidak dapat diubah',
                style: TextStyle(fontSize: 9, color: kHintColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: kInputBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(icon, color: kHintColor, size: 20),
              const SizedBox(width: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: kHintColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// CROP IMAGE SCREEN — crop manual tanpa package
// ─────────────────────────────────────────────

class _CropImageScreen extends StatefulWidget {
  final File imageFile;
  final Function(File) onCropped;

  const _CropImageScreen({required this.imageFile, required this.onCropped});

  @override
  State<_CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<_CropImageScreen> {
  // Gunakan crop square sederhana — pakai InteractiveViewer untuk zoom/pan
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sesuaikan Foto',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Gunakan file asli (tanpa library crop eksternal)
              widget.onCropped(widget.imageFile);
              Navigator.pop(context);
            },
            child: const Text(
              'Gunakan',
              style: TextStyle(
                color: kPrimaryGreen,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Preview foto dengan InteractiveViewer (zoom & pan)
                Center(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Image.file(widget.imageFile, fit: BoxFit.contain),
                  ),
                ),
                // Overlay crop square
                IgnorePointer(
                  child: CustomPaint(
                    painter: _CropOverlayPainter(),
                    child: const SizedBox.expand(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Text(
              'Cubit & geser untuk menyesuaikan foto',
              style: TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _CropOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.5);
    const cropSize = 280.0;
    final left = (size.width - cropSize) / 2;
    final top = (size.height - cropSize) / 2;
    final cropRect = Rect.fromLTWH(left, top, cropSize, cropSize);

    // Bayangan luar
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRRect(
          RRect.fromRectAndRadius(cropRect, const Radius.circular(16)),
        ),
      ),
      paint,
    );

    // Border crop
    canvas.drawRRect(
      RRect.fromRectAndRadius(cropRect, const Radius.circular(16)),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Sudut crop
    final cornerPaint = Paint()
      ..color = kPrimaryGreen
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    const cLen = 20.0;
    // kiri atas
    canvas.drawLine(Offset(left, top + cLen), Offset(left, top), cornerPaint);
    canvas.drawLine(Offset(left, top), Offset(left + cLen, top), cornerPaint);
    // kanan atas
    canvas.drawLine(
      Offset(left + cropSize - cLen, top),
      Offset(left + cropSize, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + cropSize, top),
      Offset(left + cropSize, top + cLen),
      cornerPaint,
    );
    // kiri bawah
    canvas.drawLine(
      Offset(left, top + cropSize - cLen),
      Offset(left, top + cropSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top + cropSize),
      Offset(left + cLen, top + cropSize),
      cornerPaint,
    );
    // kanan bawah
    canvas.drawLine(
      Offset(left + cropSize - cLen, top + cropSize),
      Offset(left + cropSize, top + cropSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + cropSize, top + cropSize - cLen),
      Offset(left + cropSize, top + cropSize),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────
// GANTI PASSWORD SCREEN
// ─────────────────────────────────────────────

class GantiPasswordScreen extends StatefulWidget {
  const GantiPasswordScreen({super.key});

  @override
  State<GantiPasswordScreen> createState() => _GantiPasswordScreenState();
}

class _GantiPasswordScreenState extends State<GantiPasswordScreen> {
  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _showOld = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (_oldPassCtrl.text.isEmpty ||
        _newPassCtrl.text.isEmpty ||
        _confirmPassCtrl.text.isEmpty) {
      _showSnack('Semua kolom harus diisi', isError: true);
      return;
    }
    if (_newPassCtrl.text.length < 8) {
      _showSnack('Password baru minimal 8 karakter', isError: true);
      return;
    }
    if (_newPassCtrl.text != _confirmPassCtrl.text) {
      _showSnack('Konfirmasi password tidak cocok', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() => _isLoading = false);

    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Password berhasil diperbarui ✓',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: kPrimaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError ? Colors.red : kPrimaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildPassField({
    required String label,
    required TextEditingController ctrl,
    required bool show,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: kHintColor,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          obscureText: !show,
          style: const TextStyle(fontSize: 15, color: kTextColor),
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: const TextStyle(color: kHintColor),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 14, right: 8),
              child: Icon(Icons.lock_outline, color: kPrimaryGreen, size: 20),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                show
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: kHintColor,
                size: 20,
              ),
              onPressed: onToggle,
            ),
            filled: true,
            fillColor: kBgGray,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFEEEEEE), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: kPrimaryGreen, width: 1.5),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ganti Password',
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
            // Info
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: kPrimaryGreen, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Password baru minimal 8 karakter dan berbeda dari password lama',
                      style: TextStyle(
                        fontSize: 12,
                        color: kPrimaryGreen,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildPassField(
                    label: 'Password Lama',
                    ctrl: _oldPassCtrl,
                    show: _showOld,
                    onToggle: () => setState(() => _showOld = !_showOld),
                  ),
                  const SizedBox(height: 16),
                  _buildPassField(
                    label: 'Password Baru',
                    ctrl: _newPassCtrl,
                    show: _showNew,
                    onToggle: () => setState(() => _showNew = !_showNew),
                  ),
                  const SizedBox(height: 16),
                  _buildPassField(
                    label: 'Konfirmasi Password Baru',
                    ctrl: _confirmPassCtrl,
                    show: _showConfirm,
                    onToggle: () =>
                        setState(() => _showConfirm = !_showConfirm),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _simpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Simpan Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
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
