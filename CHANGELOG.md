## 2.10.0

- Update a dependency.

## 2.9.0

- Update dependencies.

## 2.8.0

- Update dependencies & Dart SDK version (Dart 2.19.6).

## 2.7.0

- Update dependencies.

## 2.6.0

- Update dependencies & Dart SDK version (Dart 2.19.4).

## 2.5.0

- Update dependencies & Dart SDK version (Dart 2.19.2).

## 2.4.0

- Update dependencies & Dart SDK version.
- Add dependabot.yml to automate package updates.
- Add "prefer_single_quotes" linter.
- Remove 1 unused import from BoxHiveProductExtension.

## 2.3.0

- Update some dependencies.
- When asking a user to give a proper number of a product (when there are multiple found products in the "run mode"), save correctly price to Hive products (use the total price when there's only one product in the receipt product; otherwise use the price per unit).

## 2.2.0

- Add price & EAN code fields for a HiveProduct object. Add them when solving products in "run mode".
- In Hive handling, add "import from CSV" feature.
- Enhance HiveProduct filtering.
- Enhance HiveProduct updating & deleting (ask for a keyword before updating/deleting = make these processes easier for a user).
- Some refactoring in Hive handling.

## 2.1.0

- Add support for exporting Hive products to a CSV file.

## 2.0.0

- Update the whole codebase to use [kassakuitti package](https://pub.dev/packages/kassakuitti).
- Remove old unnecessary files.
- Change Excel (xlsx) to the default export file format.

## 0.10.0 - 1.0.2

- Basic logic for S-kaupat & K-ruoka.
