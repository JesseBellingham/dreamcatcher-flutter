import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamcatcher/models/dream.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _myDreams = <Dream>[];
final _biggerFont = const TextStyle(fontSize: 18.0);

class NewDream extends StatefulWidget {
  @override
  NewDreamState createState() => new NewDreamState();
}

class NewDreamState extends State<NewDream> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dream Catcher'),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.list),
            onPressed: _goToMyDreams
          ),
        ],
      ),
      body: NewDreamForm()
    );
  }
  void _goToMyDreams() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _myDreams.map(
            (Dream dream) {
              return new ListTile(
                title: new Text(
                  dream.dreamName,
                  style: _biggerFont,
                ),
                subtitle: new Text("Is public: ${dream.makePublic}"),
              );
            }
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles
          ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: const Text('My Dreams'),
            ),
            body: new ListView(children: divided),
          );
        }
      )
    );
  }
}

class NewDreamForm extends StatefulWidget {
  @override
  NewDreamFormState createState() => new NewDreamFormState();
}

class NewDreamFormState extends State<NewDreamForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a `GlobalKey<FormState>`, not a GlobalKey<MyCustomFormState>! 
  final _formKey = GlobalKey<FormState>();
  var _newDream = new Dream();
  final Firestore firestore = Firestore.instance;
  CollectionReference get dreams =>  firestore.collection('dreams');

  void onChanged(bool newValue) {
    setState(() {
      _newDream.makePublic = newValue;
    });
  }

  Future<Null> submit() async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      _myDreams.add(_newDream);

      final DocumentReference document = dreams.document();
      document.setData(
        _newDream.toJson()
      );
      _newDream = new Dream();
    }
  }
  List<Widget> makePublicRadios() {
    var list = new List<Widget>();
    list.add(
      Container(
        padding: EdgeInsets.only(top: 16.0),
        child: new Row(
        children: <Widget>[
          Text("Make public?")
        ],
      ),
    ));
    list.add(
      new Row(
        children: <Widget>[
          Flexible(
            child: RadioListTile<bool>(
              title: const Text("Yes"),
              value: true,
              groupValue: _newDream.makePublic,
              onChanged: (bool newValue) {
                onChanged(newValue);
              }
            )
          ),
          Flexible(
            child: RadioListTile<bool>(
              title: const Text("No"),
              value: false,
              groupValue: _newDream.makePublic,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),),
        ],
      )
    );
    return list;
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0);
    // Build a Form widget using the _formKey we created above
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: padding,
            child: Text('Give it a name')
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              onSaved: (String value) {
                this._newDream.dreamName = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
              },
            ),
          ),
          Container(
            padding: padding,
            child: Text('What happened?')
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
              },
              onSaved: (String value) {
                this._newDream.dreamBody = value;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: makePublicRadios()
            ),
          ),
          SizedBox(
            // padding: padding,
            width: double.infinity,
            child: RaisedButton(
              color: Colors.blue[400],
              onPressed: () async {
                Scaffold.of(context)
                        .showSnackBar(SnackBar
                          (content: Text('Processing')));
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                await this.submit();
              },
              child: Text("Submit"),
            )
          )
        ],
      ),
    );
  }
}