import 'package:flutter/material.dart';

class DashboardChart extends StatelessWidget {
  const DashboardChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar('Oct 01', 0.4),
              _buildBar('Oct 10', 0.3),
              _buildBar('Oct 20', 0.5),
              _buildBar('Oct 30', 1.0), // Highlight bar
              _buildBar('Nov 10', 0.35),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Oct 01', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('Oct 10', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('Oct 20', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('Oct 30', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double height) {
    final isHighlight = label == 'Oct 30';
    return Column(
      children: [
        Container(
          width: 24,
          height: 120 * height,
          decoration: BoxDecoration(
            color: isHighlight ? Colors.orange : Colors.grey[300],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
