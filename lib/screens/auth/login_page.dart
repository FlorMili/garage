import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;

  // Paleta / estilos rápidos
  static const _blueStart = Color(0xFF2E8AF6);
  static const _blueEnd = Color(0xFF00C2FF);
  static const _cardColor = Color(0xFFF4F6F8);

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: integra aquí tu servicio real de autenticación
    await Future.delayed(const Duration(milliseconds: 900));

    setState(() => _isLoading = false);

    // Navega a Home / Search, etc.
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful (demo)')),
      );
      Navigator.pushReplacementNamed(context, 'home');

      // Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _goToRegister() {
  Navigator.pushNamed(context, 'register');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ----- Fondo con "blobs" azules -----
          const _BlobBackground(),
          // ----- Contenido -----
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: size.width < 500 ? 500 : 420,
                  ),
                  child: _buildCard(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
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
          // Avatar
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 3,
                color: _blueStart.withOpacity(.9),
              ),
              gradient: const LinearGradient(
                colors: [Colors.white, Colors.white],
              ),
            ),
            child: const Center(
              child: Icon(Icons.person, size: 44, color: Colors.black38),
            ),
          ),
          const SizedBox(height: 24),

          // Form
          Form(
            key: _formKey,
            child: Column(
              children: [
                _GradientField(
                  controller: _userCtrl,
                  hintText: 'Usuario',
                  icon: Icons.person_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Ingresa tu usuario' : null,
                ),
                const SizedBox(height: 14),
                _GradientField(
                  controller: _passCtrl,
                  hintText: '••••••••••',
                  icon: Icons.lock_rounded,
                  obscureText: _obscure,
                  validator: (v) =>
                      (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
                  suffix: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(_obscure
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded),
                  ),
                ),
                const SizedBox(height: 22),

                // Botón Login
                _GradientButton(
                  text: _isLoading ? 'Ingresando…' : 'Login',
                  onTap: _isLoading ? null : _onLogin,
                ),
                const SizedBox(height: 10),

                // Enlace Registrar
                _OutlineGradientLink(
                  text: 'Registrarse',
                  onTap: _goToRegister,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Fondo con blobs gradientes en esquinas y burbujas
class _BlobBackground extends StatelessWidget {
  const _BlobBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Esquina superior izquierda
        Positioned(
          top: -80,
          left: -60,
          child: _Blob(
            width: 240,
            height: 240,
            start: _LoginPageState._blueStart,
            end: _LoginPageState._blueEnd,
          ),
        ),
        // Esquina inferior derecha
        Positioned(
          right: -70,
          bottom: -60,
          child: _Blob(
            width: 260,
            height: 260,
            start: _LoginPageState._blueEnd,
            end: _LoginPageState._blueStart,
          ),
        ),
        // Burbujas
        Positioned(
          left: 24,
          bottom: 140,
          child: _Bubble(radius: 14, color: _LoginPageState._blueEnd.withOpacity(.6)),
        ),
        Positioned(
          left: 70,
          bottom: 110,
          child: _Bubble(radius: 8, color: _LoginPageState._blueStart.withOpacity(.55)),
        ),
        Positioned(
          left: 110,
          bottom: 90,
          child: _Bubble(radius: 18, color: _LoginPageState._blueStart.withOpacity(.45)),
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
        borderRadius: BorderRadius.circular(width), // forma orgánica
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

/// Campo de texto con fondo gradiente y borde redondeado
class _GradientField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffix;

  const _GradientField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_LoginPageState._blueEnd, _LoginPageState._blueStart],
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
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: InputBorder.none,
              hintText: hintText,
              prefixIcon: Icon(icon, color: Colors.grey[600]),
              suffixIcon: suffix,
            ),
          ),
        ),
      ),
    );
  }
}

/// Botón con gradiente sólido
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
              colors: [_LoginPageState._blueStart, _LoginPageState._blueEnd],
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

/// Enlace con contorno y leve gradiente de fondo
class _OutlineGradientLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _OutlineGradientLink({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_LoginPageState._blueEnd, _LoginPageState._blueStart],
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 105),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: _LoginPageState._blueStart,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}