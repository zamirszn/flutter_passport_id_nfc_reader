import 'package:intl/intl.dart';

String convertDateTimeToDateString(DateTime dateTime) {
  return DateFormat("MM/dd/yyyy").format(dateTime);
}

