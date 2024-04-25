import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Admin_register_form.dart';
import 'Admins.dart';
import 'controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

late Admins _selectedAdmin;
late Admins events;
List<Admins> _adminsList = [];
class Register_page extends StatefulWidget {
  const Register_page({super.key});

  @override
  State<Register_page> createState() => _Register_pageState();
}

class _Register_pageState extends State<Register_page> {

  @override
  void initState() {
    super.initState();
    getAdminsFromSheet().then((_) {   // modify this line
      setState(() {
        isLoading = false;
      });
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dropdownController = TextEditingController();
  bool isLoading = true;
  final String volontAPi = 'https://script.google.com/macros/s/AKfycbxRVLUg9ZCYxAF-WalMi-jrcY8Ux2kP2kIKQrrjMx_dZhYoCyWQil9e9vX9gJ_Z1ZCqCQ/exec';

  deleteAdminFromSheet(Admins adminS) async {
    var url = 'https://script.google.com/macros/s/AKfycbyhyi5oS4eULhA6W0aK4j9RcMoeEFHgE9mipexQCyC8-06rpcw7h6AyjqIIlSR6y3ar-A/exec';

    var response = await http.post(Uri.parse(url), body: {
      'firstName' : adminS.firstName,
      'lastName' : adminS.lastName,
      'middleName' : adminS.middleName
    });
    print(adminS.firstName + ' ' + adminS.lastName + ' ' + adminS.middleName);
    print(response.body.toString());
    getAdminsFromSheet().then((_) {   // modify this line
      setState(() {
        isLoading = false;
      });
    });
    _showSnackBar('Пользователь успешно удалён!');
  }

  getAdminsFromSheet() async {
    firstNameController.text = '';
    lastNameController.text = '';
    passwordController.text = '';
    middleNameController.text = '';
    var raw = await http.get(
        Uri.parse(volontAPi)
    );
    var jsonAdmins = convert.jsonDecode(raw.body);

    _adminsList = [];

    jsonAdmins.forEach((element){
      print(element);
      events = Admins(
        firstName: element['Имя'].toString() ?? '',
        lastName: element['Фамилия'].toString() ?? '',
        middleName: element['Отчество'].toString() ?? '',
        password: element['Пароль'].toString() ?? '',
      );
      _adminsList.add(events);
    });
  }

  void _submitForm(){
    if(_formKey.currentState?.validate() ?? false){
      Admin_register_form admin_register_form = Admin_register_form(
          firstNameController.text.toString(),
          lastNameController.text.toString(),
          middleNameController.text.toString(),
          passwordController.text.toString()
      );
      setState(() {
        isLoading = true;
      });
      FormController formController = FormController(
              (String response) {
            if(response==FormController.STATUS_SUCCESS){
              getAdminsFromSheet().then((_) {   // modify this line
                setState(() {
                  isLoading = false;
                });
              });
              _showSnackBar("Пользователь добавлен");
            }else {
              _showSnackBar("Ошибка при добавлении пользователя");
            }
          }
      );

      _showSnackBar("Пользователь добавлен!");
      formController.submitForm(admin_register_form);
    }
  }

  void _showSnackBar(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Добавить админа', style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(
            child: CircularProgressIndicator()
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Добавить админа', style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.blueAccent,
        ),
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: firstNameController,
                    validator: (value){
                      if (value!.isEmpty){
                        return "Введите имя";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Имя"
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: lastNameController,
                    validator: (value){
                      if (value!.isEmpty){
                        return "Введите фамилию";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Фамилия"
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: middleNameController,
                    validator: (value){
                      if (value!.isEmpty){
                        return "Введите отчество";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Отчество"
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    validator: (value){
                      if (value!.isEmpty){
                        return "Введите пароль";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Пароль"
                    ),
                  ),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: () {
                      _submitForm();
                    },
                    child: const Text("Добавить пользоателя",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Divider(height: 4,),
                  const SizedBox(height: 10,),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Выберете админа",
                    ),
                    items: _adminsList.map((admin) {
                      return DropdownMenuItem(
                        value: admin,
                        child: Text('${admin.firstName} ${admin.lastName} ${admin.middleName}'),
                      );
                    }).toList(),
                    onChanged: (Admins? admin) {
                      setState(() {
                        _selectedAdmin = admin!;
                        print(_selectedAdmin.firstName);
                      });
                    },
                    value: _adminsList.isNotEmpty ? _adminsList[0] : null,
                  ),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () async {
                      if (_selectedAdmin == null) {
                        _showSnackBar('Выберете админа, которого хотите удалить!');
                      } else {
                        setState(() {
                          isLoading = true;
                        });

                        var result = await deleteAdminFromSheet(_selectedAdmin);
                        _showSnackBar(result['message']);
                        if(result['status'] == "SUCCESS") {
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text(
                      "Удалить админа",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}