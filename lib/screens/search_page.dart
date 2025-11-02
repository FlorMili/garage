import 'package:flutter/material.dart';
import 'package:garage/screens/screens.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  // Paleta
  static const _blueStart = Color(0xFF2E8AF6);
  static const _blueEnd = Color(0xFF00C2FF);

  // nuevo: mostrar solo favoritos
  bool _favoritesOnly = false;

  // Datos de ejemplo
  final List<GarageItem> _garages = [
    GarageItem(
      name: 'Estacionamiento 1',
      address: 'Av. Central 1700, Villa El Salvador 15834',
      spots: 5,
    ),
    GarageItem(
      name: 'Estacionamiento 2',
      address: 'Av. Central 1700, Villa El Salvador 15834',
      spots: 2,
      isFavorite: true,
    ),
    GarageItem(
      name: 'Estacionamiento 3',
      address: 'Av. Central 1700, Villa El Salvador 15834',
      spots: 0,
    ),
    GarageItem(
      name: 'Estacionamiento 4',
      address: 'Av. Central 1700, Villa El Salvador 15834',
      spots: 10,
    ),
  ];

  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _garages.where((g) {
      final matchesQuery = g.name.toLowerCase().contains(_query.toLowerCase());
      final matchesFav = !_favoritesOnly || g.isFavorite;
      return matchesQuery && matchesFav;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Fondo superior con formas simples
          Positioned(top: -100, left: -80, child: _blob(240, 240)),
          Positioned(top: -60, right: -40, child: _circle(90)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 6),
                  const Text(
                    'Estacionamientos\nDisponibles',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _blueStart,
                      fontSize: 22,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SearchBar(
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _query = v),
                    onTapMap: () {
                      // TODO: Navegar a una pantalla de mapa
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Abrir mapa (TODO)')),
                      );
                    },
                    favoritesOnly: _favoritesOnly,
                    onToggleFavorites: () => setState(() => _favoritesOnly = !_favoritesOnly),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: .78,
                          ),
                      itemCount: filtered.length,
                      itemBuilder:
                          (_, i) => _GarageCard(
                            item: filtered[i],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => MyBookingsPage(
                                        garageName: filtered[i].name,
                                        address: filtered[i].address,
                                      ),
                                ),
                              );
                            },
                            onToggleFavorite: () {
                              setState(() {
                                // toggle sobre el mismo objeto (modifica _garages)
                                filtered[i].isFavorite = !filtered[i].isFavorite;
                              });
                            },
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

  Widget _blob(double w, double h) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_blueStart, _blueEnd],
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
        color: _blueEnd.withOpacity(.15),
        shape: BoxShape.circle,
      ),
    );
  }
}

/* ---------------------------- MODELO SIMPLE ---------------------------- */

class GarageItem {
  final String name;
  final String address;
  final String? imageAsset; // opcional si luego agregas assets
  int spots;
  bool isFavorite;

  GarageItem({
    required this.name,
    required this.address,
    this.imageAsset,
    required this.spots,
    this.isFavorite = false,
  });
}

/* --------------------------- WIDGETS REUTILIZABLES --------------------------- */

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTapMap;
  final bool favoritesOnly;
  final VoidCallback? onToggleFavorites;

  const _SearchBar({
    required this.controller,
    this.onChanged,
    this.onTapMap,
    this.favoritesOnly = false,
    this.onToggleFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Buscar por nombre…',
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Colors.black54,
              ),
              filled: true, // ✅ activa el fondo
              fillColor: Colors.white, // ✅ fondo blanco sólido
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: const BorderSide(
                  color: Color(0x22000000),
                ), // borde suave
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: const BorderSide(
                  color: Colors.blueAccent,
                  width: 1.5,
                ), // borde al enfocar
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // corazón para filtrar favoritos
        InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onToggleFavorites,
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: favoritesOnly ? Colors.pinkAccent.withOpacity(.14) : const Color(0x1100C2FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              favoritesOnly ? Icons.favorite : Icons.favorite_border_rounded,
              color: favoritesOnly ? Colors.pinkAccent : _SearchPageState._blueEnd,
            ),
          ),
        ),
        // botón mapa (sigue presente)
        InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTapMap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0x1100C2FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.map_rounded,
              color: _SearchPageState._blueEnd,
            ),
          ),
        ),
      ],
    );
  }
}

class _GarageCard extends StatelessWidget {
  final GarageItem item;
  final VoidCallback? onTap;
  final VoidCallback? onToggleFavorite;

  const _GarageCard({required this.item, this.onTap, this.onToggleFavorite});

  static const _blueStart = _SearchPageState._blueStart;
  static const _blueEnd = _SearchPageState._blueEnd;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [_blueEnd, _blueStart],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Contenido principal
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen / placeholder
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 90,
                      width: double.infinity,
                      color: Colors.white,
                      child:
                          item.imageAsset == null
                              ? const _ParkingPlaceholder()
                              : Image.asset(
                                item.imageAsset!,
                                fit: BoxFit.cover,
                              ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Título
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Dirección
                  Text(
                    item.address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(.9),
                      fontSize: 12,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),

            // ⭐ Favorito (superpuesto, no ocupa alto)
            Positioned(
              left: 8,
              bottom: 8,
              child: IconButton(
                onPressed: onToggleFavorite,
                iconSize: 22,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  item.isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                  color: item.isFavorite ? Colors.pinkAccent : Colors.white70,
                ),
              ),
            ),

            // 🚗 Badge de cupos (superpuesto, no ocupa alto)
            Positioned(
              right: 8,
              bottom: 8,
              child: _SpotsBadge(spots: item.spots),
            ),
          ],
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
      child: const Icon(
        Icons.local_parking_rounded,
        size: 48,
        color: Colors.black38,
      ),
    );
  }
}

class _SpotsBadge extends StatelessWidget {
  final int spots;
  const _SpotsBadge({required this.spots});

  @override
  Widget build(BuildContext context) {
    final available = spots > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: available ? Colors.white : Colors.white.withOpacity(.85),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            Icons.directions_car_filled_rounded,
            size: 16,
            color: available ? Colors.black87 : Colors.black45,
          ),
          const SizedBox(width: 4),
          Text(
            '$spots',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: available ? Colors.black87 : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}
