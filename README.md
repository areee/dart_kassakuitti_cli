<a href="https://github.com/areee/dart_kassakuitti_cli/releases"><img alt="GitHub release (latest by date)" src="https://img.shields.io/github/v/release/areee/dart_kassakuitti_cli"></a>
<a href="https://github.com/areee/dart_kassakuitti_cli/blob/main/LICENSE.md"><img alt="GitHub" src="https://img.shields.io/github/license/areee/dart_kassakuitti_cli"></a>

# dart_kassakuitti_cli

> A simple Dart CLI app to handle a cash receipt coming from S-kaupat or K-ruoka (two Finnish food online stores).

## Installation

See the installation in [its own page](https://www.yle.fi).

## Usage

### Needed files
- An EAN file = an HTML file (.html) → needed when using both S-kaupat and K-ruoka
  - Generate an HTML file by using `snapshot-as-html` project (see the [installation](#installation)).
  - To generate that, go to an active order page of an online store:
    - [s-kaupat.fi](https://www.s-kaupat.fi) (profile image → "Tilaukset" → "Katso tilaustiedot") or
    - [k-ruoka.fi](https://www.k-ruoka.fi) (profile image → "Tilaukset" → expand the latest order).
  - Then click the `snapshot-as-html` extension image and click "Capture it!".
  - An HTML file will be generated and saved to your computer's Downloads folder.
- A cash receipt file = a plain text file (.txt) → only needed when using S-kaupat
    - Ensure that you have enabled an electronic cash receipt service in S-kanava.
    - Go to [s-kanava.fi](https://www.s-kanava.fi) and select ["Kassakuitit" page](https://www.s-kanava.fi/web/s/oma-s-kanava/asiakasomistaja/kassakuitit).
    - Select a cash receipt you want to view. Select needed rows by painting from the first product row to the total row. Copy them.
    - Open a text editor (e.g. Notepad or TextEdit) and paste copied cash receipt rows. Save the file as a plain text file (.txt).

### Default usage

The basic usage looks like this (an assumption is that we're in the project folder):

```
dart run bin/dart_kassakuitti_cli.dart run -t [a path to the cash receipt file] -h [a path to the EAN file] -s [S-kaupat or K-ruoka] -c [a path to generated CSV files]
```

Or, by using the [alias](#alias) (works anywhere in your local environment):

```
kassakuitti run -t [a path to the cash receipt file] -h [a path to the EAN file] -s [S-kaupat or K-ruoka] -c [a path to generated CSV files]
```

You can define
- a cash receipt (`-t` = text file),
- an EAN products file (`-h` = html file),
- (optional: which food online store to use (`-s` = store)) and
- where to save the output files (`-c` = CSV file).

S-kaupat is a default choice for the food online store selection (`-s`).

#### An example

```
kassakuitti run -t /Users/username/Downloads/cash_receipt.txt -h /Users/username/Downloads/https___www.s-kaupat.fi_tilaus_product_id-generating_time.html -s S-kaupat -c /Users/username/Downloads
```

### Help

If you want to get all the available commands, you can just type:

```
dart run bin/dart_kassakuitti_cli.dart help
```

Or, by using the [alias](#alias):

```
kassakuitti help
```

### Basic information

If you want some basic information about this program (e.g. the description, the version number or the project homepage), just type:

```
dart run bin/dart_kassakuitti_cli.dart
```

Or, by using the [alias](#alias):

```
kassakuitti
```

## Alias

If you want to get an easier command, you can create an alias into Zsh or Bash profile file (e.g. `~/.zshrc` when using Zsh and `~/.bashrc` when using Bash). This line adds an alias `kassakuitti` into the profile file (let's assume that this `dart_kassakuitti_cli` project locates under your Documents folder):

```
alias kassakuitti='dart run $HOME/Documents/dart_kassakuitti_cli/bin/dart_kassakuitti_cli.dart'
```

## Generate `hive_product.g.dart` file

You can generate `hive_product.g.dart` file by running:

```
dart run build_runner build
```