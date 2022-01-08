# dart_kassakuitti_cli

A simple Dart CLI app to handle a cash receipt coming from S-kaupat or K-ruoka (two Finnish food online stores).


## Usage

You can define a cash receipt (t = text file), an EAN products file (h; html file) and which food online store to use (s).

Let's suppose that you are in the root level of the project.

```
dart run bin/dart_kassakuitti_cli.dart -t assets/files/_cashReceipt.txt -h assets/files/_orderedProducts_S-kaupat.html -s S-kaupat
```