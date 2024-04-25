import 'dart:convert';
import 'dart:typed_data';

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
  String firstName ='';
  String lastName='';
  String middleName='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Вход',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Имя',
                  ),
                ),
                const SizedBox(height: 20,),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Фамилия',
                  ),
                ),
                const SizedBox(height: 20,),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: _middleNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Отчество',
                  ),
                  obscureText: false,
                ),
                const SizedBox(height: 20,),
                _isValidLogin ? TextField(
                  controller: _additionalInfoController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Пароль',
                  ),
                  obscureText: true,
                ) : Container(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    firstName = _firstNameController.text;
                    lastName = _lastNameController.text;
                    middleName = _middleNameController.text;

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
                              MaterialPageRoute(builder: (context) => AdminPage(
                                firstName: firstName,
                                lastName: lastName,
                                middleName: middleName,)),
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
                          MaterialPageRoute(
                            builder: (context) => EventPage(
                              firstName: firstName,
                              lastName: lastName,
                              middleName: middleName,
                            ),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Войти',
                    style: TextStyle(
                        color: Colors.white
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