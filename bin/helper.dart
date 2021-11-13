import 'package:intl/intl.dart';

class Helper {
  PreviousLine previousLine;
  int calcLines;

  Helper({this.previousLine = PreviousLine.notSet, this.calcLines = 0});
}

enum PreviousLine { notSet, refund }

/// Formatted date time for file name.
String formattedDateTime() {
  return DateFormat('yyyyMMddHHmmss').format(DateTime.now());
}
