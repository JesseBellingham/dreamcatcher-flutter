import 'package:flutter/cupertino.dart';

class Item {
  String title;
  IconData icon;
  Function onClick;
  Item(this.title, this.icon, this.onClick);
}