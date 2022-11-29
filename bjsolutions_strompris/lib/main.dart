import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const List<String> list = <String>[
  'NO1 Oslo',
  'NO2 Kr.Sand',
  'NO3 Tr.heim',
  'NO4 Tromsø',
  'NO5 Bergen'
];
void main() {
  runApp(const StromprisApp());
}

class StromprisApp extends StatelessWidget {
  const StromprisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Norske Strømpriser',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Norske Strømpriser'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[DropdownButtonExample()],
          ),
        ),
      ),
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    getStromPris(dropdownValue);
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          getStromPris(value);
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  void getStromPris(var areacode) async {
    var api = "/api/v1/prices";

    api = api + "/" + DateTime.now().year.toString();
    if (DateTime.now().month < 10) {
      api = "$api/0${DateTime.now().month}";
    } else {
      api = "$api/${DateTime.now().month}";
    }
    if (DateTime.now().day < 10) {
      api = "$api-0${DateTime.now().day}";
    } else {
      api = "$api-${DateTime.now().day}";
    }
    areacode = areacode.split(' ').first;
    api = "${api}_$areacode.json";

    var url = Uri.https("hvakosterstrommen.no", api);

    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
