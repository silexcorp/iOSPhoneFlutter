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
      },
    );
  }
}

class RecentCalls extends StatefulWidget {
  @override
  _RecentCallsState createState() => _RecentCallsState();
}

class _RecentCallsState extends State<RecentCalls> {
  String _allOrMissedControlGroupValue = kAllCalls;
  ListState _listState = ListState.VIEWING;
  bool _showMissingOnly = false;
  int _bottomBarIndex = 1;

  Widget getAppbarFromBottomBarIndex(int index) {
    /// Depending on the index of the bottom bar, we want to show different
    /// states of the Appbar. Sometimes it is just header, but often it contains
    /// some control elements. So functions contains the configuration logic for
    /// the this.
    /// 0 - Favourites
    /// 1 - Recents
    /// 2 - Contacts
    /// 3 - Keypad
    /// 4 - Voicemail

    if (index == 0) {
    } else if (index == 1) {
      /// We need to show differnt controls depending on the state of the list.
      /// If Edit was pressed, then we need to show two buttons: Clear and Done.
      /// Otherwise we need to show just one button: edit.
      return AppBar(
        backgroundColor: kColorGreyShade200,
        elevation: 0,
        title: Container(
          color: kColorGreyShade200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Visibility(
                // This allows to keep occupying space so that other controls in
                // this row do not move left or right when widget becomes
                // invisible
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                // This control is invisible if we are not editing the list
                visible: _listState == ListState.EDITING,
                child: InkWell(
                  child: Text("Clear", style: kAppleActionButtonTextStyle),
                  onTap: () {},
                ),
              ),
              CupertinoSegmentedControl(
                groupValue: _allOrMissedControlGroupValue,
                onValueChanged: (key) {
                  // Again, we set our state depending on what mode we are in
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
                // Sizebox to occupy enough space. Done takes more pixels than
                // Edit, therefore we need to reserve this space so that stuff
                // of the left does not float around.
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
      // Contacts
      return AppBar(
        elevation: 0,
        backgroundColor: kColorGreyShade200,
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
      // We have NO appbar for keypad
    } else if (index == 4) {
      // Voicemail section
      return AppBar(
        elevation: 0,
        backgroundColor: kColorGreyShade200,
      );
    }
  }

  Widget getPageFromBottombar(int index) {
    /// Depending on the index, we need to get different pages for our app.
    /// Same logic applies here:
    /// 0 - Favourites
    /// 1 - Recents
    /// 2 - Contacts
    /// 3 - Keypad
    /// 4 - Voicemail
    if (index == 0) {
      return Container();
    } else if (index == 1) {
      return Column(
        children: <Widget>[
          Expanded(
            flex: 10,
            child: ListView(
              // We get out listview from function call.
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
    /// Function returns a list of widgets that contain information that
    /// depends on the following variables:
    /// onlyMissed - boolean telling whether to show only calls that were missed
    /// state - Are we editing or viewing the list? Depending on that, we need
    /// different icons in each record
    ///

    // Final output
    List<Widget> newListOfCalls = [];

    // In iOS when you scroll list of calls up, Recents text captions disappears
    // To simulate this behaviour, we will put this caption as a part of the ListView.
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

    // Basically, go through each call, depending on our requests include or
    // not included non-missed calls.
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
    /// Initially we just need to get a list of calls and fill the list out
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
      // Nothing to complicated, get bottom bar and the main page of the app
      appBar: getAppbarFromBottomBarIndex(_bottomBarIndex),
      body: getPageFromBottombar(_bottomBarIndex),
    );
  }
}
