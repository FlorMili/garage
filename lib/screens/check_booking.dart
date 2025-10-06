import 'package:flutter/material.dart';

class CheckBookingPage extends StatelessWidget {
  const CheckBookingPage({super.key, this.garageName});

  /// Opcional: mostrar el nombre del estacionamiento confirmado
  final String? garageName;

  static const _blueStart = Color(0xFF2E8AF6);
  static const _blueEnd = Color(0xFF00C2FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Blobs decorativos
          Positioned(
            top: -90,
            left: -80,
            child: _blob(240, 240),
          ),
          Positioned(
            bottom: -80,
            right: -60,
            child: _blob(260, 260, reverse: true),
          ),
          Positioned(
            bottom: 110,
            left: 40,
            child: _circle(18),
          ),
          Positioned(
            bottom: 70,
            left: 80,
            child: _circle(10),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  const Text(
                    'Gracias por su\nReserva',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _blueStart,
                      fontSize: 24,
                      height: 1.15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Card central
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 520, // limita el ancho en tablets
                        padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: LinearGradient(
                            colors: [Colors.white, const Color(0xFFE6F3FF)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 18,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (garageName != null) ...[
                              Text(
                                garageName!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                            // Check verde
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFF22C55E),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 6,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 16,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                size: 64,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Solo tiene 15 min de tolerancia; pasado ese tiempo\n'
                              'se procederá a cancelar la reserva.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                height: 1.35,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Acciones
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _OutlineButton(
                                  text: 'Ver Mis Reservas',
                                  onTap: () {
                                    // Navega a tu pestaña "Reservas" del Home
                                    Navigator.pop(context); // cierra confirmación
                                    // Si tienes pestañas controladas en Home, puedes
                                    // enviar un event o usar rutas nombradas aquí.
                                  },
                                ),
                                const SizedBox(width: 12),
                                _PrimaryButton(
                                  text: 'Ir al inicio',
                                  onTap: () {
                                    Navigator.popUntil(
                                      context,
                                      (route) => route.isFirst,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helpers visuales
  Widget _blob(double w, double h, {bool reverse = false}) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: reverse ? [_blueEnd, _blueStart] : [_blueStart, _blueEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(w),
      ),
    );
  }

  Widget _circle(double d) {
    return Container(
      width: d,
      height: d,
      decoration: BoxDecoration(
        color: _blueEnd.withOpacity(.18),
        shape: BoxShape.circle,
      ),
    );
  }
}

/* ----------------------------- Botones UI ----------------------------- */

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _PrimaryButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [CheckBookingPage._blueStart, CheckBookingPage._blueEnd],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5)),
          ],
        ),
        child: const Text(
          'Ir al inicio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _OutlineButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: CheckBookingPage._blueStart,
        side: const BorderSide(color: CheckBookingPage._blueStart, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: onTap,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}