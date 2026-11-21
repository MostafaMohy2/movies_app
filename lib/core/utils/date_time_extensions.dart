import 'package:flutter/material.dart';

extension DateTimeExtensions on TimeOfDay {
  DateTime get dateTime => DateTime(0, 0, 0, hour, minute, 0);
}
