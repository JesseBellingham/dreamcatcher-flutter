import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamcatcher/models/dream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final _biggerFont = const TextStyle(fontSize: 18.0);

class PublicDreams extends StatefulWidget {
  @override
  PublicDreamsState createState() => new PublicDreamsState();
}

class PublicDreamsState extends State<PublicDreams> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dream Catcher'),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.add),
            onPressed: _goToNewDream
          ),
        ],
      ),
      body: new StreamBuilder(
        stream: Firestore.instance.collection('dreams').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading dreams...");
          return PublicDreamsList(snapshot);
        }
      )
    );
      // PublicDreamsList());
  }

  void _goToNewDream() {
    Navigator.of(context).pushNamed('/NewDream');
  }
}

class PublicDreamsList extends StatefulWidget {
  AsyncSnapshot snapshot;
  PublicDreamsList(AsyncSnapshot snapshot)
  {
    this.snapshot = snapshot;
  }

  @override
  PublicDreamsListState createState() => new PublicDreamsListState(snapshot);
}
class PublicDreamsListState extends State<PublicDreamsList> {
  AsyncSnapshot snapshot;
  PublicDreamsListState(AsyncSnapshot snapshot)
  {
    this.snapshot = snapshot;
  }

  @override
  Widget build(BuildContext context) {
    List<Dream> publicDreams = new List<Dream>();
    this.snapshot.data.documents.forEach(
      (DocumentSnapshot ds) {
        publicDreams.add(new Dream.withAll(
          ds["name"],
          ds["body"],
          ds["created_at"],
          ds["make_public"],
          ds["rating"]
        ));
      }
    );
    final Iterable<ListTile> tiles = publicDreams.map(
      (Dream dream) {
        return new ListTile(
          title: new Text(
            dream.dreamBody,
            style: _biggerFont,
          ),
        );
      }
    );

    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles
    ).toList();

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Public Dreams'),
      ),
      body: new ListView(children: divided),
    );
  }
}