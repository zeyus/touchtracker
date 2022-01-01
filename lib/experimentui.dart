// base screen class for displaying a list of items
import 'package:flutter/material.dart';

class BasePageWidget extends StatelessWidget {
  BasePageWidget({Key? key}) : super(key: key);

  final List<String> items = [];
  Widget method1() {
    return Column(
      children: <Widget>[
        // Text('You can put other Widgets here'),
        for (var item in items) Text(item),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: method1(),
    );
  }
}
