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

AnsiPen peachPen() {
  return AnsiPen()
    ..black(bold: true)
    ..rgb(r: 1.0, g: 0.8, b: 0.2);
}
