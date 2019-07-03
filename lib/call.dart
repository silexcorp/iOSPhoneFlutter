import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:intl/intl.dart';

enum CallSource { PHONE, SKYPE, WHATSUP, TELEGRAM }

Map<CallSource, String> sourceMapping = {
  CallSource.PHONE: "phone",
  CallSource.SKYPE: "Skype",
  CallSource.WHATSUP: "What's up",
  CallSource.TELEGRAM: "Telegram Audio",
};
//Whether we received this call or it was an outgiung one
enum InOut { IN, OUT }

class PhoneCall {
  PhoneCall({this.name, this.source, this.time, this.inout, this.isMissed});

  final String name;
  final CallSource source;
  final DateTime time;

  final InOut inout;
  bool isMissed;
}


class CallRecordWidget extends StatelessWidget {
  CallRecordWidget({this.call, this.state});

  final PhoneCall call;
  final ListState state;

  String _callTimeToString(DateTime datetime) {
    var diff = DateTime.now().difference(datetime);
    if (diff.inDays < 1) {
      return "${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}";
    } else if (diff.inDays <= 7) {
      return DateFormat('EEEE').format(datetime);
    } else {
      var formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(datetime);
    }
  }

  List<Widget> getRowChildren(ListState state) {
    List<Widget> list = [];
    if (state == ListState.EDITING) {
      list.add(
        Expanded(
          flex: 1,
          child: Icon(Icons.remove_circle, color: Colors.red),
        ),
      );
    }
    list.add(
      Expanded(
        flex: 1,
        child: Icon(call.inout == InOut.IN ? null : Icons.call_made,
            color: Colors.grey.shade300),
      ),
    );
    list.add(Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            call.name,
            style: call.isMissed
                ? kMissedCallNameTextStyle
                : kNonMissedCallNameTextStyle,
          ),
          Text(
            sourceMapping[call.source],
            style: kCallSourceTextStyle,
          ),
        ],
      ),
    ));
    List<Widget> actionIconList = [];
    actionIconList.add(
      Text(
        _callTimeToString(call.time),
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    );

    actionIconList.add(
      SizedBox(
        width: 10,
      ),
    );
    if (state == ListState.VIEWING) {
      actionIconList.add(Padding(
        padding: EdgeInsets.only(right: 5),
        child: Icon(
          CupertinoIcons.info,
          color: Colors.blue,
        ),
      ));
    }
    list.add(Expanded(
      flex: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: actionIconList,
      ),
    ));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: getRowChildren(state),
    );
  }
}