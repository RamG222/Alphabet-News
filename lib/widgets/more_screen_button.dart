import 'package:flutter/material.dart';

class more_screen_button extends StatelessWidget {
  const more_screen_button({
    super.key,
    required this.onPressed,
    required this.iconWidget,
    required this.label,
  });

  final VoidCallback? onPressed;
  final Widget iconWidget;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 10),
                iconWidget,
                SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
