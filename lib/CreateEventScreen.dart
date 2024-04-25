import 'dart:convert' as convert;
import 'EvenClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Event_form.dart';
import 'Event_controller.dart';
import 'Register.dart';
import 'package:http/http.dart' as http;

late Events _selectedAdmin;
late Events events;
List<Events> _adminsList = [];
class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {

  bool isLoading = true;
  getEventsFromSheet() async {
    eventNameController.text = '';
    categoryController.text = '';
    startDateController.text = '';
    endDateController.text = '';
    locationController.text = '';
    var raw = await http.get(
        Uri.parse(volontAPi)
    );
    var jsonAdmins = convert.jsonDecode(raw.body);

    _adminsList = [];

    jsonAdmins.forEach((element){
      print(element);
      events = Events(
        eventName: element['Название'].toString() ?? '',
        catygory: element['Категория'].toString() ?? '',
        startDate: element['Дата начала'].toString() ?? '',
        endDate: element['Дата окончания'].toString() ?? '',
        location: element['Место проведения'].toString() ?? '',
      );
      _adminsList.add(events);
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final String volontAPi = 'https://script.google.com/macros/s/AKfycbwYNl2_Oz5aozz8bVvV7C8-iNSx22xvlYiVt9D7DvX-he3ph7zDvbERgysuebKSZijG7Q/exec';

  deleteEventFromSheet(String eventName) async {
    var url = 'https://script.google.com/macros/s/AKfycbx0Oi3m6SNe0oOFDP2dbH7adsQS1JmikFLD1Zw1eDMiujamXkHEt3ydPqNqr8ShyJMP2w/exec';

    var response = await http.post(Uri.parse(url), body: {'eventName': eventName});
    getEventsFromSheet().then((_) {   // modify this line
      setState(() {
        isLoading = false;
      });
    });
    _showSnackBar('Событие успешно удалено');
  }

  void _submitForm(){
    if(_formKey.currentState?.validate() ?? false){
      Event_form event_form = Event_form(
          eventNameController.text.toString(),
          categoryController.text.toString(),
          startDateController.text.toString(),
          endDateController.text.toString(),
          locationController.text.toString()
      );
      setState(() {
        isLoading = true;
      });
      Event_controller formController = Event_controller(
              (String response) {
            print(response);
            if(response==Event_controller.STATUS_SUCCESS){
              getEventsFromSheet().then((_) {   // modify this line
                setState(() {
                  isLoading = false;
                });
              });
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
  void initState() {
    super.initState();
    getEventsFromSheet().then((_) {   // modify this line
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Добавить событие', style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.green,
        ),
        body: const Center(
            child: CircularProgressIndicator()
        ),
      );
    }
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
                      textCapitalization: TextCapitalization.words,
                      controller: eventNameController,
                      validator: (value){
                        if (value!.isEmpty){
                          return "Введите название мероприятия";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Название',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: categoryController,
                      validator: (value){
                        if (value!.isEmpty){
                          return "Введите категорию";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Категория',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: startDateController,
                      validator: (value){
                        if (value!.isEmpty){
                          return "Введите дату начала";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Дата начала',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: endDateController,
                      validator: (value){
                        if (value!.isEmpty){
                          return "Введите дату окончания";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Дата окончания',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: locationController,
                      validator: (value){
                        if (value!.isEmpty){
                          return "Введите местоположение";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Местоположение',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        _submitForm();
                      },
                      child: const Text(
                        'Добавить событие',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Divider(height: 4, color: Colors.grey,),
                    const SizedBox(height: 10,),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Выберите событие",
                      ),
                      items: _adminsList.map((event) {
                        return DropdownMenuItem(
                          value: event,
                          child: Text(event.eventName),
                        );
                      }).toList(),
                      onChanged: (Events? event) {
                        setState(() {
                          _selectedAdmin = event!;
                          print(_selectedAdmin.eventName);
                        });
                      },
                      value: _adminsList.isNotEmpty ? _adminsList[0] : null, // set default value if eventsList is not empty.
                    ),
                    const SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: () async {
                        if (_selectedAdmin == null) {
                          _showSnackBar('Выберете событие, которое хотите удалить!');
                        } else {
                          setState(() {
                            isLoading = true;
                          });

                          print(_selectedAdmin.eventName);
                          var result = await deleteEventFromSheet(_selectedAdmin.eventName);
                          _showSnackBar(result['message']);
                          if(result['status'] == "SUCCESS") {

                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text(
                        "Удалить событие",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Divider(height: 4, color: Colors.grey,),
                    const SizedBox(height: 10,),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Register_page()),
                          );
                        },
                        child: const Text(
                          "Добавить админа",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}