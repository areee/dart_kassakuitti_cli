/// Shop selector (sKaupat, kRuoka)
enum ShopSelector {
  sKaupat,
  kRuoka,
}

extension ShopSelectorExtension on ShopSelector {
  static const values = {
    ShopSelector.sKaupat: 'S-kaupat',
    ShopSelector.kRuoka: 'K-ruoka',
  };

  String? get value => values[this];

  bool isEqual(dynamic value) {
    if (value is String) {
      return toString() == value || this.value == value;
    } else {
      return false;
    }
  }
}
