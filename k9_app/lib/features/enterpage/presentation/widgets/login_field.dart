import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:k9_app/features/bottomnavbar/presentation/bottomnavbar.dart';
import 'package:k9_app/features/enterpage/providers/login_providers.dart';

class LoginField extends ConsumerWidget {
  const LoginField({
    super.key,
    this.formkey,
    this.tfEmail,
    this.tfPassword,
    this.obscureText,
    this.tfId,
  });

  final GlobalKey<FormState>? formkey;
  final TextEditingController? tfEmail;
  final TextEditingController? tfPassword;
  final bool? obscureText;
  final TextEditingController? tfId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Kullan provider'lardan gelen controller'ları, eğer prop'tan gelmişse o'yu kullan
    final emailController = tfEmail ?? ref.watch(emailControllerProvider);
    final passwordController =
        tfPassword ?? ref.watch(passwordControllerProvider);
    final idController = tfId ?? ref.watch(idControllerProvider);
    final formKey = formkey ?? ref.watch(loginFormKeyProvider);
    final isObscure = ref.watch(obscureTextProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  style: TextStyle(color: Colors.black54),
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    label: Text(
                      "E-posta",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    hint: Text(
                      "ornek@gmail.com",
                      style: TextStyle(color: Color(0xff828291)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: ValidationBuilder(
                    localeName: "tr",
                  ).email().build(),
                ),
                SizedBox(height: 30),
                //Şifre giriş kısmı başlangıç
                TextFormField(
                  style: TextStyle(color: Colors.black54),
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  cursorColor: Colors.black,
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    label: Text(
                      "Şifre",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        ref.read(obscureTextProvider.notifier).state =
                            !isObscure;
                      },

                      icon: Icon(
                        isObscure
                            ? Icons.remove_red_eye_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                    hint: Text(
                      "*********",
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: ValidationBuilder(localeName: 'tr')
                      .minLength(6)
                      .regExp(
                        RegExp(r'(?=.*[A-Z])'),
                        "En az bir büyük harf içermeli",
                      )
                      .regExp(
                        RegExp(r'(?=.*[a-z])'),
                        "En az bir küçük harf içermeli",
                      )
                      .build(),
                ),

                SizedBox(height: 30),

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
            ), //a56b1
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (formKey!.currentState?.validate() ?? false) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Bottomnavbar(userId: idController!.text),
                  ),
                );
              }
            },
            child: Text("Giriş yap"),
          ),
        ],
      ),
    );
  }
}
