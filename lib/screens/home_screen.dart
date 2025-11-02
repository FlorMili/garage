import 'package:flutter/material.dart';
import 'package:garage/widgets/bottom_navigation_bar.dart';
import 'package:garage/screens/screens.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    SearchPage(),
    MyBookingsView(),
    MyPaymentView(),
    _PlaceholderPage('Perfil'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<IconData> _icons = const [
    Icons.map_rounded,
    Icons.receipt_long_rounded,
    Icons.payment_rounded,
    Icons.person_rounded,
  ];
  final List<String> _labels = const [
    'Buscar',
    'Reservas',
    'Pago',
    'Perfil',
  ];

  /// Método para construir el fondo dinámico
  Widget _buildBackground() {
    switch (_selectedIndex) {
      case 0: // Chat
        return Container(color: Colors.transparent);

      case 1: // Ruta
        return Container(color: Colors.white);

      case 2: // Progreso
        return Container(color: Colors.white);

      case 3:
        return Container(color: Colors.white);

      default:
        return Container(color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Stack(
        children: [
          _buildBackground(), // 🎨 Fondo dinámico según la pantalla
          SafeArea(child: _widgetOptions[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        icons: _icons,
        labels: _labels,
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

/* ----------------- Helpers / Placeholders (mover a archivos luego) ----------------- */

class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage(this.title);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      ),
    );
  }
}
