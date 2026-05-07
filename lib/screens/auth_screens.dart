import 'package:flutter/material.dart';
import 'package:jtrip/services/api_service.dart';

// ─────────────────────────────────────────────
// WARNA & KONSTANTA
// ─────────────────────────────────────────────
const kPrimaryGreen = Color(0xFF2D6A4F);
const kBgGray = Color(0xFFF2F2F2);
const kInputBg = Color(0xFFEAEAEA);
const kLabelColor = Color(0xFF333333);
const kHintColor = Color(0xFFAAAAAA);
const kTextColor = Color(0xFF1A1A1A);

// ─────────────────────────────────────────────
// WIDGET UMUM
// ─────────────────────────────────────────────

class AuthInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool obscure;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  const AuthInput({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.obscure = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: kLabelColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          style: const TextStyle(fontSize: 14, color: kTextColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: kHintColor, fontSize: 14),
            filled: true,
            fillColor: kInputBg,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(color: kPrimaryGreen, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class AuthDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;
  final Widget? prefixIcon;

  const AuthDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: kLabelColor,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14, color: kTextColor),
          dropdownColor: Colors.white,
          decoration: InputDecoration(
            filled: true,
            fillColor: kInputBg,
            prefixIcon: prefixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(color: kPrimaryGreen, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class GoogleButton extends StatelessWidget {
  final String label;

  const GoogleButton({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Image.network(
          'https://www.svgrepo.com/show/475656/google-color.svg',
          height: 20,
          width: 20,
          errorBuilder: (_, __, ___) {
            return const Icon(
              Icons.g_mobiledata,
              color: Colors.red,
              size: 22,
            );
          },
        ),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: kTextColor,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFDDDDDD)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LOGIN SCREEN
// ─────────────────────────────────────────────

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  bool _showPassword = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (_emailCtrl.text.trim().isEmpty || _passwordCtrl.text.trim().isEmpty) {
      _showMessage('Email dan password wajib diisi', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ApiService.login(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
    } catch (e) {
      _showMessage(
        e.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : kPrimaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGray,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selamat datang kembali',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: kTextColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Silahkan masuk untuk melanjutkan\npetualangan',
                        style: TextStyle(
                          fontSize: 13,
                          color: kHintColor,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 28),
                      AuthInput(
                        controller: _emailCtrl,
                        label: 'Email',
                        hint: 'nama@gmail.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(
                          Icons.mail_outline,
                          color: kHintColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AuthInput(
                        controller: _passwordCtrl,
                        label: 'Kata Sandi',
                        hint: 'Masukkan kata sandi',
                        obscure: !_showPassword,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: kHintColor,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: kHintColor,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: _isLoading ? 'Memproses...' : 'Login',
                        onTap: _isLoading ? null : _onLogin,
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'Atau',
                          style: TextStyle(
                            color: kHintColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const GoogleButton(label: 'Masuk dengan Google'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun? ',
                      style: TextStyle(
                        color: kHintColor,
                        fontSize: 13,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/register');
                      },
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          color: kPrimaryGreen,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// REGISTER SCREEN
// ─────────────────────────────────────────────

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _nomorIdentitasCtrl = TextEditingController();
  final TextEditingController _tanggalLahirCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();

  String _kewarganegaraan = 'domestik';
  String _jenisIdentitas = 'nik';
  String _jenisKelamin = 'laki-laki';

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _nomorIdentitasCtrl.dispose();
    _tanggalLahirCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggalLahir() async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked != null) {
      final String year = picked.year.toString().padLeft(4, '0');
      final String month = picked.month.toString().padLeft(2, '0');
      final String day = picked.day.toString().padLeft(2, '0');

      setState(() {
        _tanggalLahirCtrl.text = '$year-$month-$day';
      });
    }
  }

  Future<void> _onRegister() async {
    if (_nameCtrl.text.trim().isEmpty ||
        _emailCtrl.text.trim().isEmpty ||
        _phoneCtrl.text.trim().isEmpty ||
        _nomorIdentitasCtrl.text.trim().isEmpty ||
        _tanggalLahirCtrl.text.trim().isEmpty ||
        _passwordCtrl.text.isEmpty ||
        _confirmPasswordCtrl.text.isEmpty) {
      _showMessage('Semua field wajib diisi', isError: true);
      return;
    }

    if (_passwordCtrl.text != _confirmPasswordCtrl.text) {
      _showMessage('Konfirmasi password tidak sama', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ApiService.register(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        noTelp: _phoneCtrl.text.trim(),
        password: _passwordCtrl.text,
        passwordConfirmation: _confirmPasswordCtrl.text,
        kewarganegaraan: _kewarganegaraan,
        jenisIdentitas: _jenisIdentitas,
        nomorIdentitas: _nomorIdentitasCtrl.text.trim(),
        jenisKelamin: _jenisKelamin,
        tanggalLahir: _tanggalLahirCtrl.text.trim(),
      );

      if (!mounted) return;

      _showMessage('Register berhasil');

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
    } catch (e) {
      _showMessage(
        e.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : kPrimaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGray,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Buat Akun Baru',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: kTextColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Lengkapi data diri Anda untuk mulai mengeksplorasi.',
                        style: TextStyle(
                          fontSize: 13,
                          color: kHintColor,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 28),
                      AuthInput(
                        controller: _nameCtrl,
                        label: 'Nama Lengkap',
                        hint: 'Masukkan nama lengkap',
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 16),
                      AuthInput(
                        controller: _emailCtrl,
                        label: 'Email',
                        hint: 'nama@gmail.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(
                          Icons.mail_outline,
                          color: kHintColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AuthInput(
                        controller: _phoneCtrl,
                        label: 'Nomor Telepon',
                        hint: '0812xxxx',
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(
                          Icons.phone_outlined,
                          color: kHintColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AuthDropdown(
                        label: 'Kewarganegaraan',
                        value: _kewarganegaraan,
                        prefixIcon: const Icon(
                          Icons.public_outlined,
                          color: kHintColor,
                          size: 20,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'domestik',
                            child: Text('Domestik'),
                          ),
                          DropdownMenuItem(
                            value: 'mancanegara',
                            child: Text('Mancanegara'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _kewarganegaraan = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      AuthDropdown(
                        label: 'Jenis Identitas',
                        value: _jenisIdentitas,
                        prefixIcon: const Icon(
                          Icons.badge_outlined,
                          color: kHintColor,
                          size: 20,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'nik',
                            child: Text('NIK'),
                          ),
                          DropdownMenuItem(
                            value: 'passport',
                            child: Text('Passport'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _jenisIdentitas = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      AuthInput(
                        controller: _nomorIdentitasCtrl,
                        label: 'Nomor Identitas',
                        hint: _jenisIdentitas == 'nik'
                            ? 'Masukkan NIK'
                            : 'Masukkan nomor passport',
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(
                          Icons.credit_card_outlined,
                          color: kHintColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AuthDropdown(
                        label: 'Jenis Kelamin',
                        value: _jenisKelamin,
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: kHintColor,
                          size: 20,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'laki-laki',
                            child: Text('Laki-laki'),
                          ),
                          DropdownMenuItem(
                            value: 'perempuan',
                            child: Text('Perempuan'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _jenisKelamin = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      AuthInput(
                        controller: _tanggalLahirCtrl,
                        label: 'Tanggal Lahir',
                        hint: 'Pilih tanggal lahir',
                        keyboardType: TextInputType.datetime,
                        readOnly: true,
                        onTap: _pilihTanggalLahir,
                        prefixIcon: const Icon(
                          Icons.calendar_today_outlined,
                          color: kHintColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AuthInput(
                        controller: _passwordCtrl,
                        label: 'Kata Sandi',
                        hint: 'Minimal 8 karakter',
                        obscure: !_showPassword,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: kHintColor,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: kHintColor,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      AuthInput(
                        controller: _confirmPasswordCtrl,
                        label: 'Konfirmasi Kata Sandi',
                        hint: 'Ulangi kata sandi',
                        obscure: !_showConfirmPassword,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: kHintColor,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: kHintColor,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _showConfirmPassword = !_showConfirmPassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: _isLoading ? 'Memproses...' : 'Daftar',
                        onTap: _isLoading ? null : _onRegister,
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'Atau daftar dengan',
                          style: TextStyle(
                            color: kHintColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const GoogleButton(label: 'Daftar dengan Google'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sudah punya akun? ',
                      style: TextStyle(
                        color: kHintColor,
                        fontSize: 13,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          color: kPrimaryGreen,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}