class Helper {
  PreviousLine previousLine;
  int calcLines;

  Helper({this.previousLine = PreviousLine.notSet, this.calcLines = 0});
}

enum PreviousLine { notSet, refund }
