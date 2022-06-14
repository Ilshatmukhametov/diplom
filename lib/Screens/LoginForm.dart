import 'package:flutter/material.dart';
import 'package:untitled6/Comm/comHelper.dart';
import 'package:untitled6/Comm/genLoginSignupHeader.dart';
import 'package:untitled6/Comm/genTextFormField.dart';
import 'package:untitled6/DatabaseHandler/DbHelper.dart';
import 'package:untitled6/Model/UserModel.dart';
import 'package:untitled6/Screens/SignupForm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled6/Screens/mainmenu.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'HomeForm.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _formKey = new GlobalKey<FormState>();

  final _conUserId = TextEditingController();
  final _conPassword = TextEditingController();
  final _conName = TextEditingController();
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  Future setSP(UserModel user) async {
    final SharedPreferences sp = await _pref;

    sp.setString("user_id", user.user_id.toString());
    sp.setString("user_name", user.user_name.toString());
    sp.setString("email", user.email.toString());
    sp.setString("password", user.password.toString());
  }

  void _showMessage() => ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Авторизация успешна'), duration: Duration(milliseconds: 1000),)
  );

  login() async {
    String uid = _conUserId.text;
    String passwd = _conPassword.text;

    if (uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Введите id пользователя'), duration: Duration(milliseconds: 1000))
      );
    } else if (passwd.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Введите пароль'), duration: Duration(milliseconds: 1000))
      );
    } else {
      await dbHelper.getLoginUser(uid, passwd).then((userData) {
        if (userData != null) {
          setSP(userData).whenComplete(() {
            _showMessage();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => menu_page()),
                    (Route<dynamic> route) => false);

          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Неверный id или пароль'), duration: Duration(milliseconds: 1000))
          );
        }
      }).catchError((error) {
        print(error);
        alertDialog(context, "Error: Login Fail");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                genLoginSignupHeader('Авторизация'),
                getTextFormField(
                    controller: _conUserId,
                    icon: Icons.person,
                    hintName: 'id пользователя'),
                SizedBox(height: 10.0),
                getTextFormField(
                  controller: _conPassword,
                  icon: Icons.lock,
                  hintName: 'Пароль',
                  isObscureText: true,
                ),
                Container(
                  margin: EdgeInsets.all(30.0),
                  width: double.infinity,
                  child: FlatButton(
                    child: Text(
                      'Войти',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: login,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Еще нет аккаунта? '),
                      FlatButton(
                        textColor: Colors.blue,
                        child: Text('Регистрация'),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => SignupForm()));
                        },
                      )
                    ],
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