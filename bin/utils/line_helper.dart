class LineHelper {
  PreviousLine previousLine;
  int calcLines;

  LineHelper({this.previousLine = PreviousLine.notSet, this.calcLines = 0});
}

enum PreviousLine { notSet, refund }
