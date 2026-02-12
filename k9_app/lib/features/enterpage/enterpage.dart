import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:k9_app/features/bottomnavbar/presentation/bottomnavbar.dart';

class Enterpage extends ConsumerStatefulWidget {
  const Enterpage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EnterpageState();
}

class _EnterpageState extends ConsumerState<Enterpage> {
  late TextEditingController tftext;
  var formkey = GlobalKey<FormState>();
  late TextEditingController tfEmail;
  late TextEditingController tfPassword;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tftext = TextEditingController();
    tfEmail = TextEditingController();
    tfPassword = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final bool obscrText = false;
    return Scaffold(
      appBar: AppBar(title: Text("K9 Vital Monitor")),
      body: DefaultTabController(
        length: 2,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              
              children: [
                //Kayıt işlemleri başlangıç
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: Colors.black,
                          indicatorColor: Colors.blueAccent,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: [
                            Tab(text: "Giriş yap"),
                            Tab(text: "Kayıt ol"),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: Colors.white,
                            height: 400,
                            child: TabBarView(
                              children: [
                                LoginField(
                                  formkey: formkey,
                                  tfEmail: tfEmail,
                                  tfPassword: tfPassword,
                                  obscureText: obscrText,
                                ),
                                Column(children: [
                                    
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginField extends StatefulWidget {
  LoginField({
    super.key,
    required this.formkey,
    required this.tfEmail,
    required this.tfPassword,
    required this.obscureText,
  });
  final bool obscureText;
  final GlobalKey<FormState> formkey;
  final TextEditingController tfEmail;
  final TextEditingController tfPassword;

  @override
  State<LoginField> createState() => _LoginFieldState();
}

late bool isObscure;

class _LoginFieldState extends State<LoginField> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isObscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    bool obscureText = widget.obscureText;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: widget.formkey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "E posta",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: widget.tfEmail,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Şifreniz: ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: widget.tfPassword,
                  cursorColor: Colors.black,
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                        print(obscureText);
                      },

                      icon: Icon(
                        isObscure
                            ? Icons.remove_red_eye_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                    hint: Text(
                      "*********",
                      style: TextStyle(fontWeight: FontWeight.w200),
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
              ],
            ), //a56b1
          ),
        ],
      ),
    );
  }
}

class TestWidget extends StatelessWidget {
  const TestWidget({super.key, required this.tftext});

  final TextEditingController tftext;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(controller: tftext),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Bottomnavbar(userId: tftext.text),
              ),
            );
          },
          child: Text(
            "Gönder",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
