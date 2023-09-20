import 'package:flutter/material.dart';

extension StringExtensions on String {
  InputDecoration generateInputDecoration({
    required void Function() onPressed,
  }) =>
      InputDecoration(
        hintText: this,
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: onPressed,
        ),
      );
}
