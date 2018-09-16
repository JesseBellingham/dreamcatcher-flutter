import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamcatcher/models/dream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final _biggerFont = const TextStyle(fontSize: 18.0);
final _publicDreams = List<Dream>();

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
        stream: Firestore.instance.collection('dreams').where("make_public", isEqualTo: true).snapshots(),
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
    loadDreamList();
    final Iterable<Widget> tiles = _publicDreams.map(
      (Dream dream) {
        return GestureDetector(
          onTap: () => _goToDreamView(dream),
          child: ListTile(
            title: Text(
              dream.body,
              style: _biggerFont,
            ),
          )
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
      body: GestureDetector(
        onVerticalDragEnd: (DragEndDetails details) {
          loadDreamList();
        },
        child: Container(
          child: ListView(children: divided,)),
      )
    );
  }

  void _goToDreamView(Dream dream) {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          // final Iterable<ListTile> tiles = _myDreams.map(
          //   (Dream dream) {
          //     return new ListTile(
          //       title: new Text(
          //         dream.dreamName,
          //         style: _biggerFont,
          //       ),
          //       subtitle: new Text("Is public: ${dream.makePublic}"),
          //     );
          //   }
          // );
          // final List<Widget> divided = ListTile.divideTiles(
          //   context: context,
          //   tiles: tiles
          // ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: const Text('My Dreams'),
            ),
            body: new Text(dream.body),
            // body: new ListView(children: divided),
          );
        }
      )
    );
  }

  loadDreamList() {
    _publicDreams.clear();
    this.snapshot.data.documents.forEach(
      (DocumentSnapshot ds) {
        _publicDreams.add(new Dream.withAll(
          ds["name"],
          ds["body"],
          ds["created_at"],
          ds["make_public"],
          ds["rating"]
        ));
      }
    );
  }
}