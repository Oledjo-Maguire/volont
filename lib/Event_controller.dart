import 'package:volont/Event_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Event_controller{
  final void Function(String) callback;

  static const String URL = "https://script.google.com/macros/s/AKfycbxFQi4eIKTE1Z3XqiL9D_ScUgsX8cI2sCW3NGBcFrueEZALDbbGw-VPpCHXGQU5a7uWXA/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  Event_controller(this.callback);

  void submitForm(Event_form Event_form) async {
    try{
      await http.get(
          Uri.parse(URL + Event_form.toParams())
      ).then((response){
        print(response.body);
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch(e){
      print(e);
    }
  }
}