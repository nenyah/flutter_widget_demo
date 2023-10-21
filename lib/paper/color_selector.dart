import 'package:flutter/material.dart';

class ColorSelector extends StatelessWidget {
  final List<Color> supportColors;
  final ValueChanged<int> onSelect;
  final int activeIndex;

  const ColorSelector({
    super.key,
    required this.supportColors,
    required this.onSelect,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Wrap(
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(
        supportColors.length,
        _buildByIndex,
      )),
    );
  }

  Widget _buildByIndex(int index) {
    bool select = index == activeIndex;
    return GestureDetector(
      onTap: () => onSelect(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.all(2),
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: select ? Border.all(color: Colors.blue) : null),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: supportColors[index],
          ),
        ),
      ),
    );
  }
}
