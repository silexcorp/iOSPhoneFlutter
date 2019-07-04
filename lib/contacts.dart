import 'dart:collection';

import 'package:flutter/material.dart';
import 'constants.dart';
import 'data_bank.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  /// This variable holds the positions in the ListView. We need that to implement
  /// the functionality of the direct jump to the given letter in the list
  Map<String, double> _letterPositions = {};
  /// Scroll controller is used to well... scroll to the given positions
  ScrollController _scrollController = new ScrollController();

  /// If we are filtering list by names, we change the layout of widget. These
  /// two variables state whether we are in the search state right now and if we a
  /// are, what searchValue tells what we are looking for.
  bool _inSearchState = false;
  String _searchValue;

  List<Widget> getStartingLetters() {
    /// This functions goes through all contacts details and finds all starting
    /// letters of the names in the list. They are later used to implement quick
    /// jump to the letter functionality
    if (_inSearchState) {
      /// When we are in the search state we do not need to display that column
      return [];
    }

    /// For simplicity, use set to keep unique letter
    Set<String> out_set = Set();
    for (String pc in names_list) {
      out_set.add(pc[0]);
    }

    /// We then need to sort that letters in the alphabetical order
    var out_list = out_set.toList();
    out_list.sort();

    /// Now we just build a list of children for the small Column on the right
    /// hand side
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
    /// This is small facade for the drawing widgets.
    /// If we are in the search state, we drawn a normal contact list
    /// Otherwise we are drawing search results widgets
    if (!_inSearchState) {
      return getContactList();
    }
    return getSearchResult();
  }

  List<Widget> getSearchResult() {
    /// Lists all the contacts that were matched against the search query.
    /// Pretty straightForward. Go through the list and check if substring matches
    /// any contacts
    List<Widget> out = [];
    for (String name in names_list) {
      if (!name.toLowerCase().contains(_searchValue)){
        continue;
      }
      if (out.isEmpty){
        /// We only need to add Top Search Results string iff we found anything
        /// Otherwise iOS leaves it empty
        out.add(Container(
          color: Colors.grey.shade300,
          height: kContactsListNameHeight,
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
        height: kContactsListNameHeight,
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
    /// This is the most interesting part as we are getting a list of contacts to
    /// display. It is interesting because we also need to prepare for the qucik jump to
    /// a letter functionality. Read below.
    List<Widget> out = [];

    /// Again, we gonna diaply those contacts in the sorted order. For that we used
    /// a tree structure which allows in-order iterations through its values.
    /// A starting letter will be the key, a the value is a list of names
    /// srarting from this letter. SplayTreeMap allows walking its key-value pairs
    /// in the sorted order.
    SplayTreeMap<String, Set<String>> groupedContacts = SplayTreeMap();

    for (String pc in names_list) {
      if (!groupedContacts.containsKey(pc[0])) {
        /// If a key is missing, add it
        groupedContacts[pc[0]] = Set<String>();
      }
      /// Then add a name as well
      groupedContacts[pc[0]].add(pc);
    }
    /// totalShift is used for quick jump to letter functionality. For a jump we
    /// need to know total height of a jump in pixels. We know how much space
    /// each row occupies, therefore we can pre-calculate positions of all letters
    double totalShift = 0;
    groupedContacts.forEach((k, v) {
      /// Iterating through all key-value pairs, init jump height with 0
      _letterPositions[k] = 0;
      out.add(
        Container(
          height: kContactsListLetterHeight,
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
      /// Init jump height we total running height accumulated so far
      _letterPositions[k] = totalShift;

      /// Increase jump height by the known height of a Letter row
      totalShift += kContactsListLetterHeight;

      for (String name in v) {
        /// Increase jump height by the know height of a name row
        totalShift += kContactsListLetterHeight;
        out.add(Container(
          height: kContactsListLetterHeight,
          child: Text(
            name,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ));
        /// We just do not want to add a Divider if there are no records left for
        /// this key
        if (ct < l - 1) {
          out.add(Divider());
          totalShift += 16;
        }
        ct++;
      }
    });
    return out;
  }

  @override
  Widget build(BuildContext context) {
    /// Building the widget. The main trick here is to use flex widget to make
    /// contacts list wide enough while keeping quick -access column very narrow
    /// on the right. Other than that it is pretty straightforward.
    return Column(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: ListView(
            children: [
              Container(
                color: kBackGroundGreyColor,
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
                      _inSearchState = searchValue.length > 0;
                      this._searchValue = searchValue.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                      hintText: "Search",
                      fillColor: kBackGroundGreyColor),
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
