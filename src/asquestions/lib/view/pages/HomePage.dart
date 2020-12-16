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
              icon: Icon(Icons.addchart_rounded),
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
                  builder: (context) =>
                      TalkQuestionsPage(widget._firestore, _talk.reference)));
        },
        child: buildCard(context, _talk, widget._firestore));
  }

//need room and description
}

Widget buildCard(
    BuildContext context, Talk talk, CloudFirestoreController _firestore) {
  final formattedStr = new DateFormat('dd-MM-yyy HH:mm');

  return Container(
    padding: const EdgeInsets.all(2.0),
    child: Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: 5.0, top: 10.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child:
                        Text(talk.title, style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 1.0),
                    child: Text(talk.host.name,
                        style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 1.0),
                    child: SizedBox(
                      width: 235.0,
                      child: Text(talk.description,
                          style: new TextStyle(fontSize: 15.0)),
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Divider(
                      height: 0,
                      thickness: 2,
                      color: Colors.blue.shade500,
                      indent: 0,
                      endIndent: 40),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 5.0, right: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formattedStr.format(talk.startDate),
                            style: new TextStyle(fontSize: 13.0)),
                        Text("Room: " + talk.room,
                            style: new TextStyle(fontSize: 13.0)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UserProfilePage(_firestore, talk.host.reference)));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue.shade500, width: 4),
                  ),
                  child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Image(image: AssetImage(talk.host.picture))),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
