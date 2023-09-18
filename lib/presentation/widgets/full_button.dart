import 'package:flutter/material.dart';

class FullButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final Color backgroundColor;

  const FullButton({
    required this.onPressed,
    required this.title,
    required this.backgroundColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor, // background color
          ),
          onPressed: onPressed,
          child: Text(title),
        ),
      ),
    );
  }
}
