import 'package:dreamcatcher/models/dream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyDreams extends StatelessWidget {
  final _myDreams = <Dream>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    final Iterable<ListTile> tiles = _myDreams.map(
      (Dream dream) {
        return new ListTile(
          title: new Text(
            dream.body,
            style: _biggerFont,
          ),
        );
      });
  }
}