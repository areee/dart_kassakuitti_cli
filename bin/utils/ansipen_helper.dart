import 'package:ansicolor/ansicolor.dart';

AnsiPen greenPen() {
  return AnsiPen()
    ..black(bold: true)
    ..green(bold: true);
}

AnsiPen redPen() {
  return AnsiPen()
    ..black(bold: true)
    ..red(bold: true);
}
