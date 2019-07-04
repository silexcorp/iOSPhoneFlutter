import 'package:flutter/material.dart';
import 'constants.dart';

/// Building Voicemail page is an extremely straightforward activity.

class VoiceMailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.grey.shade200,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                child: Text(
                  "Voicemail",
                  style: kLargeCaptionLabelTextStyle,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
                  onPressed: () {},
                  child: Text(
                    "Call voicemail",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ))
            ],
          ),
        )
      ],
    );
  }
}
