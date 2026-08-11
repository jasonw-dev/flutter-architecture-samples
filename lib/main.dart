import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/app/app.dart';
import 'package:flutter_architecture_samples/app/di.dart';

void main() {
  configureDependencies();
  runApp(App());
}
