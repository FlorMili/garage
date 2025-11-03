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

  final _plateCtrl = TextEditingController(text: '');
  final FocusNode _plateFocus = FocusNode();
  TimeOfDay? _arrival;

  @override
  void dispose() {
    _plateCtrl.dispose();
    _plateFocus.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();
    final t = await showTimePicker(context: context, initialTime: now);
    if (t != null) setState(() => _arrival = t);
  }

  void _reserve() {
    // valida hora de llegada
    if (_arrival == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona la hora de llegada')),
      );
      return;
    }
    // valida placa (no vacía)
    final plate = _plateCtrl.text.trim();
    if (plate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa la placa del vehículo')),
      );
      // poner foco en el campo placa
      FocusScope.of(context).requestFocus(_plateFocus);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Reserva creada: ${_arrival!.format(context)} | Placa $plate',
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
                  _ParkingLayout(
                    initialOccupied: {1,2,3, 4,7, 9,10,12,13,17,18,19,21,22},
                    onSelectedChanged: (selected) {
                      // opcional: reaccionar a la selección (ej. actualizar estado)
                      // debugPrint('Puestos seleccionados: $selected');
                    },
                  ),

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
                        focusNode: _plateFocus,
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

/// Plano del estacionamiento (dos filas: superior 10, inferior 12).
/// Slots verticales; solo uno puede quedar seleccionado (amarillo).
class _ParkingLayout extends StatefulWidget {
  final int topCount;
  final int bottomCount;
  final Set<int> initialOccupied;
  final ValueChanged<Set<int>>? onSelectedChanged;

  const _ParkingLayout({
    this.topCount = 10,
    this.bottomCount = 12,
    this.initialOccupied = const {},
    this.onSelectedChanged,
  });

  @override
  State<_ParkingLayout> createState() => _ParkingLayoutState();
}

class _ParkingLayoutState extends State<_ParkingLayout> {
  late final Set<int> occupied;
  int? _selected; // id seleccionado (solo uno) o null

  @override
  void initState() {
    super.initState();
    occupied = Set<int>.from(widget.initialOccupied);
  }

  void _toggle(int id) {
    if (occupied.contains(id)) return;
    setState(() => _selected = (_selected == id) ? null : id);
    widget.onSelectedChanged?.call(_selected != null ? {_selected!} : {});
  }

  Widget _buildSlot(int id) {
    final isOcc = occupied.contains(id);
    final isSelected = _selected == id;
    final bg = isOcc
        ? Colors.red
        : isSelected
            ? Colors.amber
            : Colors.grey[400];
    final textColor = isOcc ? Colors.white : (isSelected ? Colors.black : Colors.black87);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AspectRatio(
          aspectRatio: 3 / 5, // vertical rectangle
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () => _toggle(id),
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.black26, width: .8),
              ),
              child: Center(
                child: Text(
                  '$id',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = List<Widget>.generate(widget.topCount, (i) => _buildSlot(i + 1));
    final bottom = List<Widget>.generate(widget.bottomCount, (i) => _buildSlot(widget.topCount + i + 1));

    return Column(
      children: [
        // Fila superior
        SizedBox(
          height: 120,
          child: Row(children: top),
        ),
        const SizedBox(height: 8),
        // Fila inferior
        SizedBox(
          height: 120,
          child: Row(children: bottom),
        ),
      ],
    );
  }
}
