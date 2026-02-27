import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupField extends ConsumerStatefulWidget {
  const SignupField({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupFieldState();
}

class _SignupFieldState extends ConsumerState<SignupField> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          
        )
      ],
    );
  }
}