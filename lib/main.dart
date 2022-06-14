import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'Screens/LoginForm.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Новости',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: LoginForm(),
    );
  }
}