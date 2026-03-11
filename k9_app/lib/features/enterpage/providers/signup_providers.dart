import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// TextEditingController providers
final signupEmailControllerProvider = Provider((ref) {
  return TextEditingController();
});

final signupPasswordControllerProvider = Provider((ref) {
  return TextEditingController();
});

final signupIdControllerProvider = Provider((ref) {
  return TextEditingController();
});

// Login form key provider
final signupLoginFormKeyProvider = Provider((ref) {
  return GlobalKey<FormState>();
});

// Obscure text state provider for password visibility toggle
final signupObscureTextProvider = StateProvider<bool>((ref) {
  return true;
});
