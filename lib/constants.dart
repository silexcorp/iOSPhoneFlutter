import 'package:flutter/material.dart';

final Color kBackGroundGreyColor = Colors.grey.shade200;

final TextStyle kLargeCaptionLabelTextStyle = TextStyle(
  fontSize: 50,
  backgroundColor: kBackGroundGreyColor,
  fontWeight: FontWeight.bold,
);

const TextStyle kNonMissedCallNameTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

const TextStyle kMissedCallNameTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.red,
);

const TextStyle kAppleActionButtonTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.blue,
);

const TextStyle kAppleActionButtonTextStyleAccent = TextStyle(
  fontSize: 20,
  color: Colors.blueAccent,
//  fontWeight:  FontWeight.bold
);

const TextStyle kCallSourceTextStyle = TextStyle(
  color: Colors.grey,
);

enum ListState { EDITING, VIEWING }

const Map<ListState, String> editButtonText = {
  ListState.EDITING: "Done",
  ListState.VIEWING: "Edit"
};

const String kAllCalls = "All";
const String kMissedCalls = "Missed";

const double kDialPadButtonSpacing = 20;

const Map<String, String> numToTextMapping = {
  "1": "",
  "2": "A B C",
  "3": "D E F",
  "4": "G H I",
  "5": "J K L",
  "6": "M N O",
  "7": "P Q R S",
  "8": "T U V",
  "9": "W X Y Z",
  "0": "+",
  "*": "",
  "#": ""
};

const kKeyPadNumberTextStyle = TextStyle(
  fontSize: 45,
  fontWeight: FontWeight.w400,
);

final kColorGreyShade200 = Colors.grey.shade200;