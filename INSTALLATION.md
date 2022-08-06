# Installation

## Prerequisites
- Dart (e.g. comes with Flutter)
- Google Chrome
- Git

## Install Chrome extension, clone this project & get dependencies

1. Download a Chrome extension called "[snapshot-as-html](https://github.com/areee/snapshot-as-html)" (edited by the author of this project).
    - In the [latest release page](https://github.com/areee/snapshot-as-html/releases/latest), go to the assets section and click the "Source code (zip)" link. It'll download the source code to your computer.
    - Unzip the zip file.
    - Open Google Chrome and go to the [Extensions page](chrome://extensions) (chrome://extensions).
    - Enable the developer mode and click "Load unpacked". Browse to the unzipped folder (e.g. `snapshot-as-html-0.1.0`) and go to the subdirectory (`snapshot-as-html`). That folder should include all the extension files, e.g. `manifest.json`. Click "Select" in the open dialog and Google Chrome will load the extension.
2. Git clone this project (or Code → Download ZIP) under your Documents folder (or anywhere you like). Set an alias to use it with `kassakuitti` command (see the next section).
3. Go to the project folder (`cd dart_kassakuitti_cli`) and get the project dependencies (`dart pub get`).

## Set an alias

Use `kassakuitti` alias by adding the row below to your profile file. Here we're assuming you have cloned this project under your Documents folder.

```
alias kassakuitti='dart run $HOME/Documents/dart_kassakuitti_cli/bin/dart_kassakuitti_cli.dart'
```

If you're unsure where to save the alias, this might help you:

- If you're using _Zsh_ as your shell, use `~/.zshrc` profile file.
- If you're using _Bash_ as your shell, use `~/.bash_profile` profile file.