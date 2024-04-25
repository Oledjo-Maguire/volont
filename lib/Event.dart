import 'dart:convert';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'Login.dart';

Future<String> fetchPageContent(String url) async {
  var client = http.Client();
  try {
    var response = await client.get(
        Uri.parse(url),
        headers: {'User-Agent': 'Custom user agent'}
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Ошибка загрузки страницы: ${response.statusCode}');
    }
  } finally {
    client.close();
  }
}
String createMessage(String firstName, String lastName, String middleName, String eventName) {
  // Склейка ФИО и названия события в одну строку
  return '$lastName $firstName $middleName, заявил об участии в событии: "$eventName"!';
}
void sendEmailWithAttachment(String firstName, String lastName, String middleName, String eventName) async {
  String username = 'volontapp@outlook.com'; // Замените на ваш адрес электронной почты
  String password = 'jodtdiehtdglqsou'; // Замените на ваш пароль

  final smtpServer = SmtpServer('smtp-mail.outlook.com',
      port: 587,
      username: username,
      password: password,
      ssl: false, // Для Outlook используется TLS, а не SSL
      ignoreBadCertificate: true // Используйте это с осторожностью
  );

  String messageBody = createMessage(firstName, lastName, middleName, eventName); // Используем уже существующую функцию для создания сообщения

  final message = Message()
    ..from = Address(username, 'Name') // Замените 'Your Name' на ваше имя
    ..recipients.add('volontapp@outlook.com') // Адрес получателя
    ..subject = 'Письмо о участии: $eventName' // Тема письма включает название события
    ..text = messageBody; // Берем текст сообщения

  try {
    final sendReport = await send(message, smtpServer);
    print('Письмо отправлено: $sendReport');
  } catch (e) {
    print('Ошибка отправки письма: $e');
  }
}
class EventPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String middleName;

  EventPage({Key? key, required this.firstName, required this.lastName, required this.middleName}) : super(key: key);
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool _isLoading = true;
  List<String> id = [];
  List<String> name = [];
  List<String> categories = [];
  List<String> eventPeriod = [];
  List<String> organization = [];
  List<String> location = [];
  List<String> imageLinks = [];
  int i = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    /*

*/
    // String api = http.get(Uri.parse('https://script.google.com/macros/s/AKfycbwYNl2_Oz5aozz8bVvV7C8-iNSx22xvlYiVt9D7DvX-he3ph7zDvbERgysuebKSZijG7Q/exec')) as String;
    String url = 'https://dobro.ru/search?t=e&e%5Bsettlement%5D%5Btitle%5D=Краснодар&e%5Bsettlement%5D%5Bregion%5D=23&e%5Bsettlement%5D%5Blat%5D=45.040216&e%5Bsettlement%5D%5Blon%5D=38.975996&e%5Bsettlement%5D%5BcountryCode%5D=RU&e%5Bonline%5D=0'; // URL
    String volontApi = 'https://script.google.com/macros/s/AKfycbwYNl2_Oz5aozz8bVvV7C8-iNSx22xvlYiVt9D7DvX-he3ph7zDvbERgysuebKSZijG7Q/exec';

    try {
      try {
        var volontResponse = await http.get(Uri.parse(volontApi));

        if (volontResponse.statusCode == 200) {
          List<dynamic> volontData = json.decode(volontResponse.body);
          for (var event in volontData) {
            id.insert(0, 'kubsau'); // Пустой ID, так как не предоставляется API
            name.insert(0, event['Название']);
            categories.insert(0, event['Категория']);
            eventPeriod.insert(0, '${event['Дата начала']} - ${event['Дата окончания']}');
            organization.insert(0, 'КубГАУ');
            location.insert(0, event['Место проведения']);
            imageLinks.insert(0, ''); // Установите путь к изображению в папке assets
          }
        } else {
          throw Exception('Ошибка при загрузке из Volont API: ${volontResponse.statusCode}');
        }
      } catch (e) {
        print('Ошибка при загрузке страницы: $e');
        print("Количество итераций: $i");
      }
      finally{
        setState(() {
          _isLoading = false; // Завершение загрузки
        });
      }
        // После загрузки и добавления данных из Volont API, продолжаем загружать другие данные...



      String htmlContent = await fetchPageContent(url);
      const String startMarker = '"e":[{';
      const String endMarker = '],"e_filtered"';
      int startIndex = htmlContent.indexOf(startMarker);
      int endIndex = htmlContent.indexOf(endMarker, startIndex);
      if (startIndex != -1 && endIndex != -1) {
        // Обрезаем данные для последующей обработки
        String data = htmlContent.substring(startIndex + startMarker.length, endIndex);

        List<String> entries = data.split('}},{"id"');
        for (String entry in entries) {
          //   print("Количество итераций: $entry");
          // Ищем и добавляем name
          int idStartIndex = entry.indexOf(':')+1;
          int idEndIndex = entry.indexOf(',"name":');
          id.add(entry.substring(idStartIndex, idEndIndex));

          int nameStartIndex = entry.indexOf('"name":') + 8;
          int nameEndIndex = entry.indexOf(',"categories":[', nameStartIndex)-1;
          name.add(entry.substring(nameStartIndex, nameEndIndex));

          // Добавляем categories (предполагая, что categories и eventPeriod разделены маркером eventPeriod)
          int categoriesStartIndex = entry.indexOf('"title":') ;
          int categoriesEndIndex = entry.indexOf('}],', categoriesStartIndex);
          //categories.add(entry.substring(categoriesStartIndex, categoriesEndIndex));
          String categoriesEntry = entry.substring(categoriesStartIndex, categoriesEndIndex);
          categories.add(categoriesEntry.substring(categoriesEntry.indexOf('"title":"')+9, categoriesEntry.indexOf('","bgIcon') ));
          // Добавляем eventPeriod
          int eventPeriodStartIndex = entry.indexOf('"eventPeriod"') + 14;
          int eventPeriodEndIndex = entry.indexOf('"imageFile"', eventPeriodStartIndex);
          // eventPeriod.add(entry.substring(eventPeriodStartIndex, eventPeriodEndIndex));
          String  eventPeriodEntry = entry.substring(eventPeriodStartIndex, eventPeriodEndIndex);
          eventPeriod.add( eventPeriodEntry.substring(eventPeriodEntry.indexOf('"shortTitle":"')+14, eventPeriodEntry.indexOf('","startDate') ));

          int imageLinksStartIndex = entry.indexOf('"imageFile"') + 11;
          int imageLinksEndIndex = entry.indexOf(',"organizer"', imageLinksStartIndex);
          // imageLinks.add(entry.substring(imageLinksStartIndex, imageLinksEndIndex));
          String  imageLinksEntry = entry.substring(imageLinksStartIndex, imageLinksEndIndex);
          imageLinks.add( imageLinksEntry.substring(imageLinksEntry.indexOf('"url":"')+7, imageLinksEntry.indexOf('","id"') ));

          // Добавляем organization
          int organizationStartIndex = entry.indexOf('"organization","name"') + 16;
          int organizationEndIndex = entry.indexOf('"location":', organizationStartIndex);
          //organization.add(entry.substring(organizationStartIndex, organizationEndIndex));
          String  organizationEntry = entry.substring(organizationStartIndex, organizationEndIndex);
          organization.add( organizationEntry.substring(organizationEntry.indexOf('"name":"')+8, organizationEntry.indexOf('","statistic') ));

          // Добавляем location (предполагая, что location между countryName и timezone)
          int locationStartIndex = entry.indexOf('"countryName":"') + 15;
          int locationEndIndex = entry.lastIndexOf('"timezone"');
          //location.add(entry.substring(locationStartIndex, locationEndIndex));
          String  locationEntry = entry.substring(locationStartIndex, locationEndIndex);
          location.add( locationEntry.substring(locationEntry.indexOf('"title":')+9, locationEntry.indexOf('","region"') ));

          i++; // Увеличиваем счетчик итераций
        }
        print("Количество итераций: $i");
        print("id: $id");
      } else {
        print('Не удалось извлечь данные между маркерами.');
      }
    } catch (e) {
      print('Ошибка при загрузке страницы: $e');
      print("Количество итераций: $i");
    }
    finally{
      setState(() {
        _isLoading = false; // Завершение загрузки
      });
    }
  }
  @override

  Widget build(BuildContext context) {
    // Переключение между индикатором загрузки, сообщением о пустых данных и списком событий
    return Scaffold(
      appBar: AppBar(title: Text('События', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.amber,),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // показать индикатор загрузки
          : i == 0
          ? Center(child: Text('Данные не найдены')) // показать сообщение, если данных нет
          : ListView.builder(
        itemCount: i,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () async {
                if (id[index] == "kubsau") {
                  // Показать диалоговое окно с сообщением и кнопками "Да" и "Нет"
                  final bool? result = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Участие в событии'),
                        content: const Text('Вы хотите участвовать?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              // Закрыть диалог с возвратом значения "false"
                              Navigator.pop(context, false);
                            },
                            child: const Text('Нет'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Закрыть диалог с возвратом значения "true"
                              Navigator.pop(context, true);
                            },
                            child: const Text('Да'),
                          ),
                        ],
                      );
                    },
                  );

                  // Если пользователь нажал "Да", можно выполнить дальнейшие действия
                  if (result == true) {
                    // Предполагаем, что у вас есть переменная eventName с названием события, на которое пользователь решил нажать
                    sendEmailWithAttachment(widget.firstName, widget.lastName, widget.middleName, name[index]);
                  }
                } else {
                  // Текущий код для обработки других ID, не равных "kubsau"
                  final String url = 'https://dobro.ru/event/${id[index]}';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Не могу запустить $url';
                  }
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // Растягиваем карточку по ширине родителя
                children: <Widget>[
                  // Если id равно 'kubsau', загружаем локальное изображение.
                  // В противном случае загружаем изображение с URL.
                  id[index] == "kubsau"
                      ? Image.asset('assets/images/kubsau.jpg', fit: BoxFit.cover)
                      : (imageLinks[index].isNotEmpty
                      ? Image.network(imageLinks[index], fit: BoxFit.cover)
                      : Container()), // Пустой контейнер, если изображения нет.
                  ListTile(
                    title: Text(name[index]),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(categories[index]),
                        Text(eventPeriod[index]),
                        Text(organization[index]),
                        Text(location[index]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },

      ),
    );
  }
}