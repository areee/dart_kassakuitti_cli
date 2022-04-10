# dart_kassakuitti_cli

A simple Dart CLI app to handle a cash receipt coming from S-kaupat or K-ruoka (two Finnish food online stores).

## Installation

- Download a Chrome extension called "[snapshot-as-html](https://github.com/areee/snapshot-as-html)" (edited by the author of this project)
    - In the [latest release page](https://github.com/areee/snapshot-as-html/releases/latest), go to the assets section and click the "Source code (zip)" link. It'll download the source code to your computer.
    - Unzip the zip file.
    - Open Google Chrome and go to the [Extensions page](chrome://extensions/) (chrome://extensions/).
    - Enable the developer mode and click "Load unpacked". Browser to the unzipped folder (e.g. snapshot-as-html-0.1.0) and go to the subdirectory (snapshot-as-html). That folder should include all the extension files, e.g. `manifest.json`. Click "Select" and Google Chrome will load the extension.

## Usage

### Needed files
- An EAN file = a HTML file (.html) → needed when using both S-kaupat and K-ruoka
- A cash receipt file = a plain text file (.txt) → only needed when using S-kaupat

### Default usage

Basic usage with defaults looks like this (assumption is that we're in the project folder):

```
dart run bin/dart_kassakuitti_cli.dart
```

Or, by using the [alias](#alias) (works anywhere in your local environment):

```
kassakuitti
```

### Define options:

You can define a cash receipt (t = text file), an EAN products file (h = html file), which food online store to use (s = store) and where to save the output files (c = CSV file):

```
dart run bin/dart_kassakuitti_cli.dart -t assets/files/_cashReceipt.txt -h assets/files/_orderedProducts_S-kaupat.html -s S-kaupat -c assets/files
```

Or, by using the [alias](#alias):

```
kassakuitti -t assets/files/_cashReceipt.txt -h assets/files/_orderedProducts_S-kaupat.html -s S-kaupat -c assets/files
```

### Default options:

If you don't define any options, these are default options:
- Path to the cash receipt: `assets/files/_cashReceipt.txt`
- Path to the EAN products file: `assets/files/_orderedProducts_S-kaupat.html`
- Selected store: `S-kaupat`
- Path where to save CSV files: `assets/files`

### Help

If you want to get all the available commands, you can just type:

```
dart run bin/dart_kassakuitti_cli.dart help
```

Or, by using the [alias](#alias):

```
kassakuitti help
```

## Alias

If you want to get an easier command, you can create an alias into Zsh or Bash profile file (e.g. `~/.zshrc` when using Zsh and `~/.bashrc` when using Bash). This line adds an alias `kassakuitti` into the profile file (let's assume that this `dart_kassakuitti_cli` project locates under your Documents folder):

```
alias kassakuitti='dart run $HOME/Documents/dart_kassakuitti_cli/bin/dart_kassakuitti_cli.dart'
```