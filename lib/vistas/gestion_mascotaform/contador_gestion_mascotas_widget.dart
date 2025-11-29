import 'package:flutter/material.dart';

class ContadorBonitoWidget extends StatelessWidget {
  final IconData icon;
  final int count;
  final String title;
  final Color color;
  final Color bgColor;

  const ContadorBonitoWidget({
    super.key,
    required this.icon,
    required this.count,
    required this.title,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 6),
            Text(
              "$count",
              style: TextStyle(
                  fontSize: 22, color: color, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 14,
                  color: color.withOpacity(.9),
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
