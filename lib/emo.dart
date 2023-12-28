import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class Demo extends StatelessWidget {
  const Demo({super.key});

  _getData() async {
    var response =
        await http.get(Uri.parse('https://localhost:5001/api/users'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
