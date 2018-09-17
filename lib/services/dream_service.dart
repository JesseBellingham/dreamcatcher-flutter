import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamcatcher/models/dream.dart';
import 'package:flutter/widgets.dart';

class DreamService {
  AsyncSnapshot db;

  Iterable<Dream> getPublicDreams() {
    // this.db.data.documents
    var list = List<Dream>();
    this.db.data.documents.forEach(
      (DocumentSnapshot ds) {
        list.add(new Dream.withAll(
          ds["name"],
          ds["body"],
          ds["created_at"],
          ds["make_public"],
          ds["rating"]
        ));
      }
    );
    return list;
  }
}