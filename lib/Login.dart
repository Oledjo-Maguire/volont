import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AdminPage.dart';
import 'Users.dart';
import 'Event.dart';
import 'Register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'Admins.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _additionalInfoController = TextEditingController();

  bool _isValidLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Вход'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'Имя',
                  ),
                ),
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Фамилия',
                  ),
                ),
                TextField(
                  controller: _middleNameController,
                  decoration: InputDecoration(
                    labelText: 'Отчество',
                  ),
                  obscureText: false,
                ),
                _isValidLogin ? TextField(
                  controller: _additionalInfoController,
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                  ),
                  obscureText: true,
                ) : Container(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String firstName = _firstNameController.text;
                    String lastName = _lastNameController.text;
                    String middleName = _middleNameController.text;

                    if(firstName.isEmpty || lastName.isEmpty || middleName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Все поля должны быть заполнены.'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    } else {
                      final usersProvider = Provider.of<AdminsProvider>(context, listen: false);

                      setState(() {
                        _isValidLogin = usersProvider.checkLogin(firstName, lastName, middleName);
                      });

                      if (_isValidLogin) {
                        if(_additionalInfoController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Введите пароль.'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        } else {
                          String password = _additionalInfoController.text;
                          bool isValidPass = usersProvider.checkPassword(password);
                          if (isValidPass) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AdminPage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Неверный пароль.'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EventPage()),
                        );
                      }
                    }
                  },
                  child: Text('Войти'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
