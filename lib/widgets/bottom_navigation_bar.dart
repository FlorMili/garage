import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final List<IconData> icons;
  final List<String> labels;
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.icons,
    required this.labels,
    required this.selectedIndex,
    required this.onItemTapped,
  })  : assert(icons.length == labels.length),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(icons.length, (index) {
            final isSelected = index == selectedIndex;
            return GestureDetector(
              onTap: () => onItemTapped(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Línea amarilla visible solo si está seleccionado
                  Container(
                    height: 3,
                    width: 90,
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF2E8AF6) : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Icon(
                    icons[index],
                    size: 28,
                    color: isSelected ? const Color(0xFF2E8AF6) : Color(0xFF818181),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? Color(0xFF234F72) : Colors.black45,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}