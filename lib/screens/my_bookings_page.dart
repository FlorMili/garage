import 'package:flutter/material.dart';
import 'package:garage/screens/check_booking.dart';

class MyBookingsPage extends StatefulWidget {
  final String garageName;
  final String address;

  const MyBookingsPage({
    super.key,
    required this.garageName,
    required this.address,
  });

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  static const _blueStart = Color(0xFF2E8AF6);
  static const _blueEnd = Color(0xFF00C2FF);

  final _plateCtrl = TextEditingController(text: 'ATW123');
  TimeOfDay? _arrival;

  @override
  void dispose() {
    _plateCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();
    final t = await showTimePicker(context: context, initialTime: now);
    if (t != null) setState(() => _arrival = t);
  }

  void _reserve() {
    if (_arrival == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona la hora de llegada')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Reserva creada: ${_arrival!.format(context)} | Placa ${_plateCtrl.text}',
        ),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckBookingPage(garageName: widget.garageName),
      ),
    );
    // TODO: integra con tu backend y navega a confirmación o a "Mis Reservas".
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Blob decorativo superior
          Positioned(
            top: -80,
            left: -70,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_blueStart, _blueEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(220),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 6),
                  const Text(
                    'Realizar la Reserva',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: _blueStart,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Título del estacionamiento
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Estacionamiento 1',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Plano del parking (placeholder con boxes)
                  const _ParkingLayout(),
                  const SizedBox(height: 10),

                  // Leyenda
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _LegendDot(color: Colors.red, label: 'Ocupado'),
                      SizedBox(width: 18),
                      _LegendDot(color: Colors.grey, label: 'Disponible'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Hora de llegada
                  _LabeledField(
                    label: 'Hora de Llegada:',
                    child: _GradientBox(
                      onTap: _pickTime,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _arrival == null
                                ? 'Seleccionar…'
                                : _arrival!.format(context),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Icon(
                            Icons.calendar_month_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Placa de vehículo
                  _LabeledField(
                    label: 'Placa de vehículo:',
                    child: _GradientBox(
                      child: TextField(
                        controller: _plateCtrl,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botón reservar
                  GestureDetector(
                    onTap: _reserve,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          colors: [_blueStart, _blueEnd],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Reservar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
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
}

/* ------------------------- Widgets auxiliares ------------------------- */

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.black87)),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(flex: 7, child: child),
      ],
    );
  }
}

class _GradientBox extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _GradientBox({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    final box = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            _MyBookingsPageState._blueEnd,
            _MyBookingsPageState._blueStart,
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
    return onTap == null
        ? box
        : InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: box,
        );
  }
}

/// Plano del estacionamiento (placeholder con boxes ocupados en rojo)
class _ParkingLayout extends StatelessWidget {
  const _ParkingLayout();

  @override
  Widget build(BuildContext context) {
    final occupied = {1, 4, 9, 12}; // IDs ficticios de puestos ocupados

    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: 16, // 2 filas de 8 como ejemplo
          itemBuilder: (_, i) {
            final id = i + 1;
            final isOcc = occupied.contains(id);
            return Container(
              decoration: BoxDecoration(
                color: isOcc ? Colors.red : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black26, width: .8),
              ),
              child: Center(
                child: Text(
                  '$id',
                  style: TextStyle(
                    color: isOcc ? Colors.white : Colors.black45,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
