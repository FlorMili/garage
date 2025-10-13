import 'package:flutter/material.dart';
import 'package:garage/screens/screens.dart';

class PaymentSummaryPage extends StatefulWidget {
  const PaymentSummaryPage({super.key});

  @override
  State<PaymentSummaryPage> createState() => _PaymentSummaryPageState();
}

class _PaymentSummaryPageState extends State<PaymentSummaryPage> {
  final TextEditingController _parkingController = TextEditingController(
    text: 'Estacionamiento 1',
  );
  final TextEditingController _startController = TextEditingController(
    text: '14:00',
  );
  final TextEditingController _endController = TextEditingController(
    text: '16:00',
  );
  final TextEditingController _priceController = TextEditingController(
    text: '1',
  );
  final TextEditingController _totalController = TextEditingController(
    text: '2',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // decoraciones tipo blob
          Positioned(top: -80, left: -80, child: _blob(220, 220)),
          Positioned(
            bottom: -80,
            right: -70,
            child: _blob(220, 220, reverse: true),
          ),
          Positioned(bottom: 120, left: 50, child: _circle(16)),
          Positioned(bottom: 80, left: 28, child: _circle(9)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Resumen de Pago',
                    style: TextStyle(
                      color: Color(0xFF2E8AF6),
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _summaryCard(),
                  const SizedBox(height: 30),
                  _payButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _inputField('Estacionamiento:', _parkingController),
          const SizedBox(height: 10),
          _inputField('Hora de Inicio:', _startController),
          const SizedBox(height: 10),
          _inputField('Hora Fin:', _endController),
          const SizedBox(height: 10),
          _inputField('Precio por Hora:', _priceController),
          const SizedBox(height: 10),
          _inputField('Total:', _totalController),
        ],
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E8AF6), Color(0xFF00C2FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _payButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
        backgroundColor: const Color(0xFF2E8AF6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pago realizado con éxito')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => const PaymentSuccessPage(
                  name: 'Juan Pérez',
                  plate: 'ABC-123',
                  paymentDate: '12/10/2025',
                  hour: '16:00',
                ),
          ),
        );
      },
      child: const Text(
        'Pagar',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }

  // Decoraciones (mismo estilo que las otras pantallas)
  Widget _blob(double w, double h, {bool reverse = false}) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              reverse
                  ? [const Color(0xFF00C2FF), const Color(0xFF2E8AF6)]
                  : [const Color(0xFF2E8AF6), const Color(0xFF00C2FF)],
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
        color: const Color(0xFF00C2FF).withOpacity(.18),
        shape: BoxShape.circle,
      ),
    );
  }
}
