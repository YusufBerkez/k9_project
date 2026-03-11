import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k9_app/features/enterpage/providers/signup_providers.dart';

class SignupField extends ConsumerStatefulWidget {
  const SignupField({super.key, this.tfId});
  final TextEditingController? tfId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupFieldState();
}

class _SignupFieldState extends ConsumerState<SignupField> {
  @override
  Widget build(BuildContext context) {
    final idController = widget.tfId ?? ref.watch(signupIdControllerProvider);

    return Column(
      children: [
        TextFormField(
          style: TextStyle(color: Colors.black54),
          keyboardType: TextInputType.name,
          controller: idController,
          decoration: InputDecoration(
            label: Text(
              "ID",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
