import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Widget? imageWidget;
  final IconData? icon;

  const SummaryCard({
    Key? key,
    required this.title,
    required this.value,
    this.imageWidget,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              children: [
                if (icon != null) Icon(icon, size: 20),
                if (icon != null) const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const Spacer(),
            if (imageWidget != null)
              Align(
                alignment: Alignment.center,
                child: imageWidget!,
              ),
            const Spacer(),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}