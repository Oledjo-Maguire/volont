import 'package:volont/Admin_register_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class FormController{
  final void Function(String) callback;

  static const String URL = "https://script.google.com/macros/s/AKfycbw-ExsMKcuPeAz6Zi9VchAzHct_KZ6zcNvp5QexxeJbhAoDW5_qjm6M9uDRVikWKtiJPw/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  FormController(this.callback);

  void submitForm(Admin_register_form admin_register_form) async {
    try{
      await http.get(
          Uri.parse(URL + admin_register_form.toParams())
      ).then((response){
        print(response.body);
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch(e){
      print(e);
    }
  }
}