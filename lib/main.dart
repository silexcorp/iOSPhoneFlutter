import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:iphone_calls/call.dart';
import 'package:iphone_calls/data_providers.dart';
import 'package:iphone_calls/voice_mail.dart';
import 'constants.dart';
import 'contacts.dart';
import 'keypad.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => RecentCalls(),
        '/contacts': (context) => ContactsPage(),
      },
    );
  }
}

class RecentCalls extends StatefulWidget {
  @override
  _RecentCallsState createState() => _RecentCallsState();
}

class _RecentCallsState extends State<RecentCalls> {
  List<PhoneCall> calls;
  List<Widget> callList;
  String _allOrMissedControlGroupValue;
  ListState _listState = ListState.VIEWING;
  bool _showMissingOnly = false;
  int _bottomBarIndex = 1;
  List<Widget> bottomBarChildren = [];

  Widget getAppbarFromBottomBar(int index) {
    if (index == 0) {
    } else if (index == 1) {
      return AppBar(
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
        title: Container(
          color: Colors.grey.shade200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: _listState == ListState.EDITING,
                child: InkWell(
                  child: Text("Clear", style: kAppleActionButtonTextStyle),
                  onTap: () {
                    print("You pressed clear and eveything will be deleted");
                  },
                ),
              ),
              CupertinoSegmentedControl(
                groupValue: _allOrMissedControlGroupValue,
                onValueChanged: (key) {
                  print(key);
                  if (key == kAllCalls) {
                    setState(() {
                      _showMissingOnly = false;
                      _allOrMissedControlGroupValue = kAllCalls;
                    });
                  } else {
                    setState(() {
                      _showMissingOnly = true;
                      _allOrMissedControlGroupValue = kMissedCalls;
                    });
                  }
                },
                children: {
                  kAllCalls: Padding(
                    child: Text(kAllCalls),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  kMissedCalls: Padding(
                    child: Text(kMissedCalls),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                },
              ),
              SizedBox(
                width: 40,
                child: InkWell(
                  child: Text(editButtonText[_listState],
                      style: kAppleActionButtonTextStyle),
                  onTap: () {
                    setState(() {
                      if (_listState == ListState.VIEWING) {
                        _listState = ListState.EDITING;
                      } else {
                        _listState = ListState.VIEWING;
                      }
                      getListOfCalls(_showMissingOnly, _listState);
                    });
                  },
                ),
              )
            ],
          ),
        ),
      );
    } else if (index == 2) {
      return AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade200,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Groups",
              style: kAppleActionButtonTextStyle,
            ),
            Icon(
              CupertinoIcons.add,
              color: Colors.blueAccent,
              size: 36,
            )
          ],
        ),
      );
    } else if (index == 3) {
    } else if (index == 4) {
      return AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade200,
      );
    }
  }

  Widget getPageFromBottombar(int index) {
    if (index == 0) {
      return Container();
    } else if (index == 1) {
      return Column(
        children: <Widget>[
          Expanded(
            flex: 10,
            child: ListView(
              children: getListOfCalls(_showMissingOnly, _listState),
            ),
          ),
        ],
      );
    } else if (index == 2) {
      return ContactsPage();
    } else if (index == 3) {
      return Keypad();
    } else if (index == 4) {
      return VoiceMailPage();
    }
  }

  List<Widget> getListOfCalls(bool onlyMissed, ListState state) {
    List<Widget> newListOfCalls = [];
    newListOfCalls.add(Container(
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0, left: 4.0),
        child: Text(
          "Recents",
          style: kLargeCaptionLabelTextStyle,
        ),
      ),
    ));

    for (PhoneCall call in calls_persistent.reversed) {
      if (onlyMissed && !call.isMissed) {
        continue;
      }
      newListOfCalls.add(CallRecordWidget(
        call: call,
        state: state,
      ));
      newListOfCalls.add(Divider(
        height: 20,
      ));
    }

    return newListOfCalls;
  }

  @override
  void initState() {
    getListOfCalls(false, ListState.VIEWING);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
        showUnselectedLabels: true,
        onTap: (newInex) {
          setState(() {
            _bottomBarIndex = newInex;
          });
        },
        currentIndex: _bottomBarIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text("Favourites"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            title: Text("Recents"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            title: Text("Contacts"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.keyboard),
            title: Text("Keypad"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.voicemail),
            title: Text("Voicemail"),
          ),
        ],
      ),
      appBar: getAppbarFromBottomBar(_bottomBarIndex),
      body: getPageFromBottombar(_bottomBarIndex),
    );
  }
}
