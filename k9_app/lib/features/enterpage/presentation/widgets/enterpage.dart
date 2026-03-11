import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k9_app/features/enterpage/presentation/widgets/signup_field.dart';
import 'package:k9_app/features/enterpage/presentation/widgets/login_field.dart';

class Enterpage extends ConsumerWidget {
  const Enterpage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
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
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: TabBar(
                            labelColor: Colors.black,
                            indicator: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            unselectedLabelColor: Colors.grey,

                            tabs: [
                              Tab(text: "Giriş yap"),
                              Tab(text: "Kayıt ol"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: Colors.white,
                            height: 400,
                            child: TabBarView(
                              children: [
                                LoginField(),
                                SignupField(),
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
