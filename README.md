<a href="https://github.com/areee/dart_kassakuitti_cli/releases"><img alt="GitHub release (latest by date)" src="https://img.shields.io/github/v/release/areee/dart_kassakuitti_cli"></a>
<a href="https://github.com/areee/dart_kassakuitti_cli/blob/main/LICENSE.md"><img alt="GitHub" src="https://img.shields.io/github/license/areee/dart_kassakuitti_cli"></a>

# dart_kassakuitti_cli

> A simple Dart CLI app to handle a cash receipt coming from S-kaupat or K-ruoka (two Finnish food online stores).

## Installation

See the installation in [its own page](https://github.com/areee/dart_kassakuitti_cli/blob/main/INSTALLATION.md).

## Usage

### Needed files
- An EAN file = an HTML file (.html) → needed when using both S-kaupat and K-ruoka
  - Generate an HTML file by using `snapshot-as-html` project (see the [installation](https://github.com/areee/dart_kassakuitti_cli/blob/main/INSTALLATION.md)).
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

### Basic usage

The basic usage looks like this:

```
kassakuitti run -t [a path to the cash receipt file] -h [a path to the EAN file] -s [S-kaupat or K-ruoka] -p [a path to generated files] -f [csv or Excel = xlsx]
```

#### Choices (flags) for `kassakuitti run` command

Mandatory | Abbreviation | Meaning | Default choice
:---: | :---: | :---: | :---:
✅ | `-t` | **Text** file (a cash receipt) | -
✅ | `-h` | **Html** file (an EAN products file) | -
&nbsp; | `-s` | Which food online **store** to use | S-kaupat
&nbsp; | `-p` | **Path** where to save the output files | User's Downloads folder (`~/Downloads`)
&nbsp; | `-f` | In which file **format** the output files will be saved | csv

#### An example #1 (minimum choices)

```
kassakuitti run -t /Users/username/Downloads/cash_receipt.txt -h /Users/username/Downloads/https___www.s-kaupat.fi_tilaus_product_id-generating_time.html
```

#### An example #2 (maximum choices)

```
kassakuitti run -t /Users/username/Downloads/cash_receipt.txt -h /Users/username/Downloads/https___www.s-kaupat.fi_tilaus_product_id-generating_time.html -s S-kaupat -p ~/Downloads -f csv
```

### Help

If you want to get all the available commands, you can just type:

```
kassakuitti help
```

### Basic information

If you want some basic information about this program (e.g. the description, the version number or the project homepage), just type:

```
kassakuitti
```

The CLI gives also the same result when typing anything that's not recognized by the program, e.g.:

```
kassakuitti moro
```

(For non-Finnish speakers: "moro" means hello in Tampere, Finland.)

### Hive handling

You can handle a local Hive database that the program is using by typing:

```
kassakuitti hive
```

This starts an own interface for handling the following alternatives:

1. Create a receipt name – EAN name product.
2. Read all products (gives index numbers for each product).
3. Search a product by a keyword (gives index numbers for each product).
4. Update a product by an index number.
5. Delete a product by an index number.
6. Count products.

Each product in the Hive database has an own index number. If a product gets deleted, the next new product won't get the same index number that the previously deleted product had but a next unused index number.

## Participate to developing

See a brief instruction for developing is in [its own page](https://github.com/areee/dart_kassakuitti_cli/blob/main/DEVELOPING.md).