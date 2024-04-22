import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Login.dart';
import 'Users.dart';
import 'Admins.dart';
import 'Register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'Admins.dart';

List<Admins> _adminsList = [];
late Admins admins;

void main() {
  runApp(MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  getAdminsFromSheet() async {
    var raw = await http.get(
        Uri.parse(
            "https://script.google.com/macros/s/AKfycbxRVLUg9ZCYxAF-WalMi-jrcY8Ux2kP2kIKQrrjMx_dZhYoCyWQil9e9vX9gJ_Z1ZCqCQ/exec"
        )
    );
    var jsonAdmins = convert.jsonDecode(raw.body);

    jsonAdmins.forEach((element){
      print(element);
      admins = Admins(
        password: element['Пароль'].toString() ?? '',
        firstName: element['Имя'].toString() ?? '',
        lastName: element['Фамилия'].toString() ?? '',
        middleName: element['Отчество'].toString() ?? '',
      );
      _adminsList.add(admins);
    });
  }

  @override
  void initState() {
    try{
      getAdminsFromSheet();
    } catch(e){
      print(e);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AdminsProvider(),
        child: MaterialApp(
          title: 'Вход',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: LoginScreen(),
        )
    );
  }
}

class AdminsProvider extends ChangeNotifier {

  List<Admins> get adminsList => _adminsList;

  void addAdmin(Admins admin) {
    _adminsList.add(admin);
    notifyListeners();
  }

  bool checkLogin(String firstName, String lastName, String middleName) {
    for (Admins admin in _adminsList) {
      if (admin.firstName == firstName && admin.lastName == lastName && admin.middleName == middleName) {
        return true;
      }
    }
    return false;
  }

  bool checkPassword(String password){
    for (Admins admin in _adminsList) {
      if (admin.password == password) {
        return true;
      }
    }
    return false;
  }
}

