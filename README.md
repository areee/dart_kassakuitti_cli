# dart_kassakuitti_cli

> A simple Dart CLI app to handle a cash receipt coming from S-kaupat or K-ruoka (two Finnish food online stores).

## Installation

1. Download a Chrome extension called "[snapshot-as-html](https://github.com/areee/snapshot-as-html)" (edited by the author of this project)
    - In the [latest release page](https://github.com/areee/snapshot-as-html/releases/latest), go to the assets section and click the "Source code (zip)" link. It'll download the source code to your computer.
    - Unzip the zip file.
    - Open Google Chrome and go to the [Extensions page](chrome://extensions) (chrome://extensions).
    - Enable the developer mode and click "Load unpacked". Browser to the unzipped folder (e.g. `snapshot-as-html-0.1.0`) and go to the subdirectory (`snapshot-as-html`). That folder should include all the extension files, e.g. `manifest.json`. Click "Select" in the open dialog and Google Chrome will load the extension.
2. Git clone this project (or Code → Download ZIP). Add an [alias](#alias) to use it with `kassakuitti` command.

## Usage

### Needed files
- An EAN file = an HTML file (.html) → needed when using both S-kaupat and K-ruoka
  - Generate an HTML file by using `snapshot-as-html` project (see the [installation](#installation)).
  - To generate that, go to an active order page of an online store: s-kaupat.fi (profile image → "Tilaukset" → "Katso tilaustiedot") or k-ruoka.fi (profile image → "Tilaukset" → expand the latest order).
  - Then click the `snapshot-as-html` extension image and click "Capture it!".
  - An HTML file will be generated and saved to your computer's Downloads folder.
- A cash receipt file = a plain text file (.txt) → only needed when using S-kaupat
    - Ensure that you have enabled an electronic cash receipt service in S-kanava.
    - Go to s-kanava.fi and select "Kassakuitit" page.
    - Select a cash receipt you want to view. Select needed rows by painting from the first product row to the total row. Copy them.
    - Open a text editor (e.g. Notepad / TextEdit) and paste copied cash receipt rows. Save the file as a plain text file (.txt).

### Default usage

Basic usage with defaults looks like this (assumption is that we're in the project folder):

```
dart run bin/dart_kassakuitti_cli.dart run -t [a path to the cash receipt file] -h [a path to the EAN file] -c [a path to generated CSV files]
```

Or, by using the [alias](#alias) (works anywhere in your local environment):

```
kassakuitti run -t [a path to the cash receipt file] -h [a path to the EAN file] -c [a path to generated CSV files]
```

You can define a cash receipt (t = text file), an EAN products file (h = html file), which food online store to use (s = store) and where to save the output files (c = CSV file). Besides, you can define the food online store (-s = store). S-kaupat is a default choice.

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