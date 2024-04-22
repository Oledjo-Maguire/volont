import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:volont/Event_form.dart';
import 'package:volont/Event_controller.dart';
import 'package:volont/Register.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  void _submitForm(){
    if(_formKey.currentState?.validate() ?? false){
      Event_form event_form = Event_form(
          eventNameController.text.toString(),
          categoryController.text.toString(),
          startDateController.text.toString(),
          endDateController.text.toString(),
          locationController.text.toString()
      );
      Event_controller formController = Event_controller(
              (String response) {
            print(response);
            if(response==Event_controller.STATUS_SUCCESS){
              _showSnackBar("Событие добавлено");
            }else {
              _showSnackBar("Ошибка при добавлении события");
            }
          }
      );
      formController.submitForm(event_form);
    }
  }

  void _showSnackBar(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Добавить событие', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: eventNameController,
                      validator: (value){
                        if (value!.isEmpty){
                          return "Введите фамилия";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Название',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: categoryController,
                      validator: (value){
                        if (value!.isEmpty){
                          return "Введите фамилия";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Категория',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: startDateController,
                      validator: (value){
                        if (value!.isEmpty){
                          return "Введите фамилия";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Дата начала',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: endDateController,
                      validator: (value){
                        if (value!.isEmpty){
                          return "Введите фамилия";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Дата окончания',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: locationController,
                      validator: (value){
                        if (value!.isEmpty){
                          return "Введите фамилия";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Местоположение',
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _submitForm();
                      },
                      child: const Text('Добавить событие'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register_page()),
                          );
                        },
                        child: Text("Добавить админа"))
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}
