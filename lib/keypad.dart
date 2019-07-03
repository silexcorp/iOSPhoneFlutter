import 'package:flutter/material.dart';
import 'constants.dart';

class Keypad extends StatefulWidget {
  @override
  _KeypadState createState() => _KeypadState();
}

class _KeypadState extends State<Keypad> {
  String typedNumber = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Text("$typedNumber",style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.w400
          ),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NumberedRoundButton(
                  num: "1",
                  onPressed: () {
                    setState(() {
                      typedNumber += "1";
                    });
                  }),
              SizedBox(
                width: 20,
              ),
              NumberedRoundButton(num: "2", onPressed: () {
                setState(() {
                  typedNumber += "2";
                });
              }),
              SizedBox(
                width: 20,
              ),
              NumberedRoundButton(num: "3", onPressed: () {
                setState(() {
                  typedNumber += "3";
                });
              }),
              SizedBox(
                width: 20,
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NumberedRoundButton(num: "4", onPressed: () {
                setState(() {
                  typedNumber += "4";
                });
              }),
              SizedBox(
                width: 20,
              ),
              NumberedRoundButton(num: "5", onPressed: () {
                setState(() {
                  typedNumber += "5";
                });
              }),
              SizedBox(
                width: 20,
              ),
              NumberedRoundButton(num: "6", onPressed: () {
                setState(() {
                  typedNumber += "6";
                });
              }),
              SizedBox(
                width: 20,
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NumberedRoundButton(num: "7", onPressed: () {
                setState(() {
                  typedNumber += "7";
                });
              }),
              SizedBox(
                width: 20,
              ),
              NumberedRoundButton(num: "8", onPressed: () {
                setState(() {
                  typedNumber += "8";
                });
              }),
              SizedBox(
                width: 20,
              ),
              NumberedRoundButton(num: "9", onPressed: () {
                setState(() {
                  typedNumber += "9";
                });
              }),
              SizedBox(
                width: 20,
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NumberedRoundButton(num: '*', onPressed: () {
                setState(() {
                  typedNumber += "*";
                });
              }),
              SizedBox(
                width: 20,
              ),
              NumberedRoundButton(num: "0", onPressed: () {
                setState(() {
                  typedNumber += "0";
                });
              }),
              SizedBox(
                width: 20,
              ),
              NumberedRoundButton(num: "#", onPressed: () {
                setState(() {
                  typedNumber += "#";
                });
              }),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                  visible: false,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: NumberedRoundButton(num: '*', onPressed: () {})),
              SizedBox(
                width: 20,
              ),
              RoundIconButton(icon: Icons.call, onPressed: () {}),
              SizedBox(
                width: 20,
              ),
              Visibility(
                visible: false,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: NumberedRoundButton(num: "#", onPressed: () {}),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class NumberedRoundButton extends StatelessWidget {
  NumberedRoundButton({this.num, this.onPressed});

  final String num;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RoundButton(
      onPressed: this.onPressed,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("$num", style: kKeyPadNumberTextStyle),
            Text("${numToTextMapping[num]}"),
          ]),
    );
  }
}

class RoundButton extends StatelessWidget {
  RoundButton({@required this.child, @required this.onPressed});

  final Widget child;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: child,
      onPressed: onPressed,
      elevation: 6.0,
      constraints: BoxConstraints.tightFor(
        width: 76.0,
        height: 76.0,
      ),
      shape: CircleBorder(),
      fillColor: Colors.grey.shade300,
    );
  }
}

class RoundIconButton extends StatelessWidget {
  RoundIconButton({@required this.icon, @required this.onPressed});

  final IconData icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(
        icon,
        size: 45,
        color: Colors.white,
      ),
      onPressed: onPressed,
      elevation: 6.0,
      constraints: BoxConstraints.tightFor(
        width: 76.0,
        height: 76.0,
      ),
      shape: CircleBorder(),
      fillColor: Colors.lightGreenAccent,
    );
  }
}
