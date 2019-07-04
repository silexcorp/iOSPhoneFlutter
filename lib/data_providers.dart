import 'data_bank.dart';
import 'call.dart';
import 'dart:math';
import 'constants.dart';



/// This one generates a list of random calls.

List<PhoneCall> getListOfRandomCalls() {
  final List<PhoneCall> out = [];
  final now = DateTime.now();
  for (int i = 0; i < RECORDS_TO_GENERATE; i++) {
    PhoneCall newPhoneCall = PhoneCall(
        // Generate random caller name
        name: names_list[Random().nextInt(names_list.length)],
        // Call source, like phone, whats up call, skype call , etc
        source: CallSource.values[Random().nextInt(4)],
        // Generate random call time, for that we subscract a random number of hours
        time: now.subtract(Duration(
            hours: Random().nextInt(HOURS_PER_DAY * MAX_DAYS_LOOK_BACK))),
        // Generate whether it was out- or ingoing call
        inout: InOut.values[Random().nextInt(2)],
        // Whether call was missed of not
        isMissed: Random().nextInt(2) == 1 ? true : false);
    // If it was an outgoing call, then obviously it could be missed, then we force
    // missed field to false.
    if (newPhoneCall.inout == InOut.OUT && newPhoneCall.isMissed) {
      newPhoneCall.isMissed = false;
    }
    out.add(newPhoneCall);
  }
  // We sort our call list by call date/time
  out.sort((a, b) => a.time.compareTo(b.time));
  return out;
}

final calls_persistent = getListOfRandomCalls();
