import 'package:flutter/material.dart';

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

class CommonButton extends StatefulWidget {
  final Widget titleWidget;
  final VoidCallback onPressed;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const CommonButton({
    super.key,
    required this.titleWidget,
    required this.onPressed,
    this.color,
    this.padding,
  });

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
      margin: const EdgeInsets.symmetric(vertical: 13),
      width: screenWidth(context),
      height: 75,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16), // Adjust the value as needed
          ),
          backgroundColor: widget.color ??  Color(0xFF4053B5),
          foregroundColor: Colors.white,
        ),
        onPressed: widget.onPressed,
        child: Padding(
          padding: widget.padding == null
              ? const EdgeInsets.all(16)
              : widget.padding!,
          child: widget.titleWidget,
        ),
      ),
    );
  }
}
