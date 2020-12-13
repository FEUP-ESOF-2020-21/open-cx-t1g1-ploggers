import 'package:asquestions/view/pages/UserProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:asquestions/controller/CloudFirestoreController.dart';
import 'package:asquestions/view/pages/TalkQuestionsPage.dart';
import 'package:asquestions/view/pages/AddTalkPage.dart';
import '../../view/widgets/CustomListView.dart';
import '../../model/Talk.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final CloudFirestoreController _firestore;

  HomePage(this._firestore);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Talk> _talks = new List();
  bool showLoadingIndicator = false;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    this.refreshModel(true);
  }

  Future<void> refreshModel(bool showIndicator) async {
    Stopwatch sw = Stopwatch()..start();
    setState(() {
      showLoadingIndicator = showIndicator;
    });
    _talks = await widget._firestore.getTalks();
    if (this.mounted)
      setState(() {
        showLoadingIndicator = false;
      });
    print("Talks fetch time: " + sw.elapsed.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Talks Page'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add_sharp),
              iconSize: 28,
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddTalkPage(widget._firestore)));
              })
        ],
      ),
      body: Column(
        children: [
          Visibility(
              visible: showLoadingIndicator, child: LinearProgressIndicator()),
          Expanded(
            child: CustomListView(
                onRefresh: () => refreshModel(false),
                controller: scrollController,
                itemCount: _talks.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildTalkCard(context, index)),
          ),
        ],
      ),
    );
  }

  Widget buildTalkCard(BuildContext context, int index) {
    final _talk = _talks[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TalkQuestionsPage(widget._firestore, _talk.reference)));
      },
      child: Container(
        padding: const EdgeInsets.all(2.0),
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child:GestureDetector(
                  onTap:  (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserProfilePage(widget._firestore, _talk.host.reference)));
                  },
                    child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image(image: AssetImage(_talk.host.picture))),
                ),
              ),
              buildCard(_talk),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(Talk talk) {
    final f = new DateFormat('dd-MM-yyy HH:mm');

    return Flexible(
      child: Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(talk.title, style: new TextStyle(fontSize: 20.0)),
            Text(talk.host.name, style: new TextStyle(fontSize: 15.0)),
            Container(
              height: 10,
            ),
            Divider(
                height: 0,
                thickness: 3,
                color: Colors.blue.shade200,
                indent: 0,
                endIndent: 40),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(f.format(talk.startDate),
                  style: new TextStyle(fontSize: 12.0)),
            ),
          ],
        ),
      ),
    );
  }
}
