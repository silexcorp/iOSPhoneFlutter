import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:iphone_calls/call.dart';
import 'package:iphone_calls/data_providers.dart';
import 'constants.dart';
import 'data_bank.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  double _LETTER_HEIGHT = 20;
  double _NAME_HEIGHT = 30;
  Map<String, double> _letterPositions = {};
  var _scrollController = new ScrollController();
  bool inSearchState = false;
  String searchValue;

  List<Widget> getStartingLetters() {
    if (inSearchState) {
      return [];
    }
    Set<String> out_set = Set();

    for (String pc in names_list) {
      out_set.add(pc[0]);
    }

    var out_list = out_set.toList();
    out_list.sort();

    List<Widget> out = [];
    out_list.forEach((l) {
      out.add(InkWell(
        onTap: () {
          _scrollController.jumpTo(
            _letterPositions[l],
          );
        },
        child: Text(
          l,
          style: kAppleActionButtonTextStyle.copyWith(fontSize: 20),
        ),
      ));
    });
    return out;
  }

  List<Widget> getContactListMaster() {
    if (!inSearchState) {
      return getContactList();
    }
    return getSearchResult();
  }

  List<Widget> getSearchResult() {
    List<Widget> out = [];
    for (String name in names_list) {
      if (!name.toLowerCase().contains(searchValue)){
        continue;
      }
      if (out.isEmpty){
        out.add(Container(
          color: Colors.grey.shade300,
          height: _NAME_HEIGHT,
          child: Text(
            "Top search results",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ));
        out.add(Divider());
      }
      out.add(Container(
        height: _NAME_HEIGHT,
        child: Text(
          name,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ));
      out.add(Divider());
    }
    return out;
  }

  List<Widget> getContactList() {
    List<Widget> out = [];

    SplayTreeMap<String, Set<String>> groupedContacts = SplayTreeMap();

    for (String pc in names_list) {
      if (!groupedContacts.containsKey(pc[0])) {
        groupedContacts[pc[0]] = Set<String>();
      }
      groupedContacts[pc[0]].add(pc);
    }
    double totalShift = 0;
    groupedContacts.forEach((k, v) {
      _letterPositions[k] = 0;
      out.add(
        Container(
          height: _LETTER_HEIGHT,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              k,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          color: Colors.grey,
        ),
      );
      int l = v.length;
      int ct = 0;
      _letterPositions[k] = totalShift;
      totalShift += _LETTER_HEIGHT;

      for (String name in v) {
        totalShift += _NAME_HEIGHT;
        out.add(Container(
          height: _NAME_HEIGHT,
          child: Text(
            name,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ));
        if (ct < l - 1) {
          out.add(Divider());
          totalShift += 16;
        }
        ct++;
      }
    });
    print(_letterPositions);
    print(groupedContacts);
    return out;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: ListView(
            children: [
              Container(
                color: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                  child: Text(
                    "Contacts",
                    style: kLargeCaptionLabelTextStyle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  onChanged: (searchValue) {
                    print(searchValue);
                    setState(() {
                      inSearchState = searchValue.length > 0;
                      this.searchValue = searchValue.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                      hintText: "Search",
                      fillColor: Colors.grey.shade200),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 13,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 30,
                child: ListView(
                  controller: _scrollController,
                  children: getContactListMaster(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: getStartingLetters(),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
