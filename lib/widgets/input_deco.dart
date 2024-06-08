import 'package:flutter/material.dart';

/// TextField의 decoration 값
class InputDeco extends InputDecoration{
  const InputDeco({
    super.labelText,
    super.hintText,
    super.labelStyle = const TextStyle(color: Colors.grey),
    super. focusedBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(width: 1, color: Colors.grey),
    ),
    super.enabledBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(width: 1, color: Colors.grey),
    ),
    super.border = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  });
}