import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volont/Admin_register_form.dart';
import 'package:volont/controller.dart';
import 'Users.dart';

class Register_page extends StatefulWidget {
  const Register_page({super.key});

  @override
  State<Register_page> createState() => _Register_pageState();
}

class _Register_pageState extends State<Register_page> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _submitForm(){
    if(_formKey.currentState?.validate() ?? false){
      Admin_register_form admin_register_form = Admin_register_form(
          firstNameController.text.toString(),
          lastNameController.text.toString(),
          middleNameController.text.toString(),
          passwordController.text.toString()
      );
      FormController formController = FormController(
              (String response) {
            if(response==FormController.STATUS_SUCCESS){
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
              padding: EdgeInsets.symmetric(vertical: 100, horizontal: 25),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: firstNameController,
                    validator: (value){
                      if (value!.isEmpty){
                        return "Введите имя";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Имя"
                    ),
                  ),
                  TextFormField(
                    controller: lastNameController,
                    validator: (value){
                      if (value!.isEmpty){
                        return "Введите фамилия";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Фамилия"
                    ),
                  ),
                  TextFormField(
                    controller: middleNameController,
                    validator: (value){
                      if (value!.isEmpty){
                        return "Введите отчество";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Отчество"
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    validator: (value){
                      if (value!.isEmpty){
                        return "Введите пароль";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Пароль"
                    ),
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () {
                      _submitForm();
                    },
                    child: Text("Добавить пользоателя"),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
