import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamcatcher/models/drawer_item.dart';
import 'package:dreamcatcher/models/dream.dart';
import 'package:dreamcatcher/services/dream_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

final _biggerFont = const TextStyle(fontSize: 18.0);
var _publicDreams = List<Dream>();
final _facebookService = FacebookLogin();
final _dreamService = DreamService();


class PublicDreams extends StatefulWidget {
  PublicDreams({
    Key key,
    this.changeLoginStatus}) : super(key: key);

  @override
  PublicDreamsState createState() => new PublicDreamsState();
  final ValueChanged<void> changeLoginStatus;
}

class PublicDreamsState extends State<PublicDreams> {
  
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading;
  FirebaseUser user;
  final drawerItems = List<Item>();
  
  _logOut() async {
    await _facebookService.logOut();
    onLoginStatusChanged(false);
  }

  onLoginStatusChanged(isLoggedIn) {
    widget.changeLoginStatus(isLoggedIn);
  }

  @override
  initState() {
    super.initState();
    drawerItems.add(Item("Log Out", Icons.exit_to_app, _logOut));
    _loading = true;
    FirebaseAuth.instance.currentUser().then((fbUser) {
      setState(() {
        user = fbUser;
        _loading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(
        GestureDetector(
          onTap: d.onClick,
          child: ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.title),
          )
        )
      );
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading:
          GestureDetector(
            onTap: () => _scaffoldKey.currentState.openDrawer(),
            child:
              Container(
                // height: 10.0,
                // width: 10.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: _loading
                      ? null
                      :  DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        user.photoUrl
                    ),
                  ),
                ),
              ),
            ),
          
        title: Text('Public Dreams'),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.add),
            onPressed: _goToNewDream
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(user.displayName),
              accountEmail: Text(user.email),),
              Column(children: drawerOptions,)
          ]
        ),
      ),
      body: new StreamBuilder(
        stream: Firestore.instance.collection('dreams').where("make_public", isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading dreams...");
          return PublicDreamsList(snapshot);
        }
      )
    );
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

          return new Scaffold(
            appBar: new AppBar(
              title: const Text('My Dreams'),
            ),
            body: Container(child:Text(dream.body)),
          );
        }
      )
    );
  }

  loadDreamList() {
    _publicDreams.clear();
    _publicDreams = _dreamService.getPublicDreams();
  }
}