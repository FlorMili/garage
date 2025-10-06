import 'package:flutter/material.dart';

class MyBookingsView extends StatelessWidget {
  const MyBookingsView({
    super.key,
    this.garageName = 'Estacionamiento 1',
    this.address = 'Av. Central 1700, Villa El Salvador 15834',
    this.imageAsset, // opcional: 'assets/garage1.jpg'
    this.priceText = 'S/ 5.00 x hora',
  });

  final String garageName;
  final String address;
  final String? imageAsset;
  final String priceText;

  static const _blueStart = Color(0xFF2E8AF6);
  static const _blueEnd = Color(0xFF00C2FF);

  void _onPay(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ir al flujo de pago (TODO)')),
    );
  }

  void _onCancel(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancelar reserva'),
        content: const Text('¿Seguro que deseas cancelar esta reserva?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sí, cancelar')),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reserva cancelada')),
      );
      // TODO: llamar API para cancelar y actualizar estado
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // blobs decorativos
          Positioned(top: -90, left: -80, child: _blob(240, 240)),
          Positioned(bottom: -70, right: -60, child: _blob(240, 240, reverse: true)),
          Positioned(bottom: 110, left: 60, child: _circle(16)),
          Positioned(bottom: 70, left: 28, child: _circle(9)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 6),
                  const Text(
                    'Mi Reserva',
                    style: TextStyle(
                      color: _blueStart,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Card de la reserva
                  _BookingCard(
                    name: garageName,
                    address: address,
                    imageAsset: imageAsset,
                    priceText: priceText,
                  ),
                  const SizedBox(height: 24),

                  // Botones Cancelar y Pagar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _PillButton(
                        text: 'Cancelar',
                        colors: const [Color(0xFFE53935), Color(0xFFEF5350)],
                        onTap: () => _onCancel(context),
                      ),
                      const SizedBox(width: 16),
                      _PillButton(
                        text: 'Pagar',
                        colors: const [_blueStart, _blueEnd],
                        onTap: () => _onPay(context),
                      ),
                    ],
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

/* --------------------------- Widgets internos --------------------------- */

class _BookingCard extends StatelessWidget {
  const _BookingCard({
    required this.name,
    required this.address,
    this.imageAsset,
    required this.priceText,
  });

  final String name;
  final String address;
  final String? imageAsset;
  final String priceText;

  static const _blueStart = MyBookingsView._blueStart;
  static const _blueEnd = MyBookingsView._blueEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 520, // limita ancho en pantallas grandes
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [_blueEnd, _blueStart],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          // Imagen / placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 110,
              height: 80,
              color: Colors.white,
              child: imageAsset == null
                  ? const _ParkingPlaceholder()
                  : Image.asset(imageAsset!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(
                  address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.9),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  priceText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
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

class _PillButton extends StatelessWidget {
  final String text;
  final List<Color> colors;
  final VoidCallback onTap;

  const _PillButton({
    required this.text,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: LinearGradient(colors: colors),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6)),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ParkingPlaceholder extends StatelessWidget {
  const _ParkingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade200, Colors.grey.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Icon(Icons.local_parking_rounded, size: 40, color: Colors.black38),
    );
  }
}