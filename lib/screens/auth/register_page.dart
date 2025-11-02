import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController(); // changed

  bool _isLoading = false;

  // Paleta
  static const _blueStart = Color(0xFF2E8AF6);
  static const _blueEnd = Color(0xFF00C2FF);
  static const _cardColor = Color(0xFFF4F6F8);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose(); // changed
    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: integra tu servicio real de registro
    await Future.delayed(const Duration(milliseconds: 900));

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro completado (demo)')),
      );
      Navigator.pushReplacementNamed(context, 'home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const _BlobBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: size.width < 500 ? 500 : 420,
                  ),
                  child: _buildCard(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 18),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          const Text(
            'REGISTRO',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _blueStart,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 18),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _GradientField(
                  controller: _nameCtrl,
                  hintText: 'Nombre',
                  icon: Icons.badge_rounded,
                  validator:
                      (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Ingresa tu nombre'
                              : null,
                ),
                const SizedBox(height: 12),
                _GradientField(
                  controller: _lastNameCtrl,
                  hintText: 'Apellido',
                  icon: Icons.person_rounded,
                  validator:
                      (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Ingresa tu apellido'
                              : null,
                ),
                const SizedBox(height: 12),
                _GradientField(
                  controller: _emailCtrl,
                  hintText: 'Correo',
                  icon: Icons.email_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Ingresa tu correo';
                    final email = RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\.\-]+$');
                    return email.hasMatch(v.trim()) ? null : 'Correo inválido';
                  },
                ),
                const SizedBox(height: 12),
                _GradientField(
                  controller: _phoneCtrl,
                  hintText: 'Celular',
                  icon: Icons.phone_rounded,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Ingresa tu celular';
                    return v.trim().length >= 6 ? null : 'Número inválido';
                  },
                ),
                const SizedBox(height: 12),
                _GradientField(
                  controller: _passwordCtrl, // changed
                  hintText: 'Contraseña', // changed
                  icon: Icons.lock_rounded, // changed
                  textCapitalization: TextCapitalization.none,
                  obscureText: true, // new: hide input
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Ingresa la contraseña';
                    return v.trim().length >= 6 ? null : 'La contraseña debe tener al menos 6 caracteres';
                  },
                ),
                const SizedBox(height: 22),
                _GradientButton(
                  text: _isLoading ? 'Registrando…' : 'Registrar',
                  onTap: _isLoading ? null : _onRegister,
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('¿Ya tienes cuenta? Inicia sesión'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ------------------------ UI Helpers (autocontenidos) --------------------- */

class _BlobBackground extends StatelessWidget {
  const _BlobBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        Positioned(
          top: -80,
          left: -60,
          child: _Blob(
            width: 240,
            height: 240,
            start: _RegisterPageState._blueStart,
            end: _RegisterPageState._blueEnd,
          ),
        ),
        Positioned(
          right: -70,
          bottom: -60,
          child: _Blob(
            width: 260,
            height: 260,
            start: _RegisterPageState._blueEnd,
            end: _RegisterPageState._blueStart,
          ),
        ),
        Positioned(
          left: 24,
          bottom: 140,
          child: _Bubble(radius: 14, color: Color(0x8800C2FF)),
        ),
        Positioned(
          left: 70,
          bottom: 110,
          child: _Bubble(radius: 8, color: Color(0x882E8AF6)),
        ),
        Positioned(
          left: 110,
          bottom: 90,
          child: _Bubble(radius: 18, color: Color(0x772E8AF6)),
        ),
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  final double width;
  final double height;
  final Color start;
  final Color end;

  const _Blob({
    required this.width,
    required this.height,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [start, end],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(width),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final double radius;
  final Color color;

  const _Bubble({required this.radius, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.35),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

class _GradientField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final bool obscureText; // new
  final Widget? suffixIcon; // optional

  const _GradientField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false, // default false
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_RegisterPageState._blueEnd, _RegisterPageState._blueStart],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Container(
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            textCapitalization: textCapitalization,
            obscureText: obscureText, // applied
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: InputBorder.none,
              hintText: hintText,
              prefixIcon: Icon(icon, color: Colors.grey[600]),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const _GradientButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled ? 1 : .7,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                _RegisterPageState._blueStart,
                _RegisterPageState._blueEnd,
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
