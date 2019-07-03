import 'data_bank.dart';
import 'call.dart';
import 'dart:math';

const int HOURS_PER_DAY = 24;
const int MAX_DAYS_LOOK_BACK = 14;
const int RECORDS_TO_GENERATE = 100;

List<PhoneCall> getListOfRandomCalls() {
  final List<PhoneCall> out = [];
  final now = DateTime.now();
  for (int i = 0; i < RECORDS_TO_GENERATE; i++) {
    PhoneCall newPhoneCall = PhoneCall(
        name: names_list[Random().nextInt(names_list.length)],
        source: CallSource.values[Random().nextInt(4)],
        time: now.subtract(Duration(
            hours: Random().nextInt(HOURS_PER_DAY * MAX_DAYS_LOOK_BACK))),
        inout: InOut.values[Random().nextInt(2)],
        isMissed: Random().nextInt(2) == 1 ? true : false);
    if (newPhoneCall.inout == InOut.OUT && newPhoneCall.isMissed) {
      newPhoneCall.isMissed = false;
    }
    out.add(newPhoneCall);
  }
  out.sort((a, b) => a.time.compareTo(b.time));
  return out;
}

final calls_persistent = getListOfRandomCalls();
