import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// TextEditingController providers
final emailControllerProvider = Provider((ref) {
  return TextEditingController();
});

final passwordControllerProvider = Provider((ref) {
  return TextEditingController();
});

final idControllerProvider = Provider((ref) {
  return TextEditingController();
});

// Login form key provider
final loginFormKeyProvider = Provider((ref) {
  return GlobalKey<FormState>();
});

// Obscure text state provider for password visibility toggle
final obscureTextProvider = StateProvider<bool>((ref) {
  return true;
});
