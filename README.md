# dart_kassakuitti_cli

A simple Dart CLI app to handle a cash receipt coming from S-kaupat or K-ruoka (two Finnish food online stores).


## Usage

### Default usage

You can define a cash receipt (t = text file), an EAN products file (h = html file) and which food online store to use (s = store).

Let's suppose that you are in the root level of the project.

```
dart run bin/dart_kassakuitti_cli.dart -t assets/files/_cashReceipt.txt -h assets/files/_orderedProducts_S-kaupat.html -s S-kaupat
```

If you don't define any options (`dart run bin/dart_kassakuitti_cli.dart`), these are the defaults:
- Path to the cash receipt: `assets/files/_cashReceipt.txt`
- Path to the EAN products file: `assets/files/_orderedProducts_S-kaupat.html`
- Selected store: `S-kaupat`

### Help

If you want to get all available commands, you can just type:

```
dart run bin/dart_kassakuitti_cli.dart help
```

### Alias

If you want to get an easier command, you can create an alias into Zsh or Bash profile file (e.g. `~/.zshrc` when using Zsh). This line adds alias `kassakuitti` into the profile file (let's assume that this project locates under your Documents folder):

```
alias kassakuitti='dart run $HOME/Documents/bin/dart_kassakuitti_cli.dart'
```