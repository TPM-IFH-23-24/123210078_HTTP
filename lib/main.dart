import 'package:flutter/material.dart';
import 'package:prak_tpm_http/view/users.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Prak TPM - Latihan HTTP',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const UsersView());
  }
}
