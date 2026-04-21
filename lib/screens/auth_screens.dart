import 'package:flutter/material.dart';

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

  const AuthInput({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.obscure = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
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

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const PrimaryButton({super.key, required this.label, this.onTap});

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
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        child: Text(label),
      ),
    );
  }
}

class GoogleButton extends StatelessWidget {
  final String label;

  const GoogleButton({super.key, required this.label});

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
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.g_mobiledata, color: Colors.red, size: 22),
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
  bool _showPassword = false;

  void _onLogin() {
    // TODO: tambahkan logika autentikasi di sini
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGray,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                // Card
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
                        label: 'Email atau username',
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
                        label: 'Kata Sandi',
                        hint: '• • • • • •',
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
                          onPressed: () =>
                              setState(() => _showPassword = !_showPassword),
                        ),
                      ),
                      const SizedBox(height: 24),

                      PrimaryButton(label: 'Login', onTap: _onLogin),
                      const SizedBox(height: 16),

                      const Center(
                        child: Text(
                          'Atau',
                          style: TextStyle(color: kHintColor, fontSize: 13),
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
                      style: TextStyle(color: kHintColor, fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/register'),
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
  bool _isObscure = true;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGray,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                      const AuthInput(
                        label: 'Nama Lengkap',
                        hint: 'Masukkan nama lengkap',
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 16),
                      const AuthInput(
                        label: 'Email',
                        hint: 'nama@gmail.com',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      const AuthInput(
                        label: 'Nomor Telepon',
                        hint: '0812xxxx',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      AuthInput(
                        label: 'Kata Sandi',
                        hint: 'Minimal 8 karakter',
                        obscure: _isObscure,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      AuthInput(
                        label: 'Konfirmasi Kata Sandi',
                        hint: 'Ulangi kata sandi',
                        obscure: _isObscure,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      PrimaryButton(
                        label: 'Daftar',
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                      const SizedBox(height: 16),

                      const Center(
                        child: Text(
                          'Atau daftar dengan',
                          style: TextStyle(color: kHintColor, fontSize: 13),
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
                      style: TextStyle(color: kHintColor, fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
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
