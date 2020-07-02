enum WeightType {
  kilos,
  pounds
}

class Weight {
  final int amount;
  final WeightType type;
  Weight(this.amount, this.type);

  @override
  String toString() {
    String typeString = this.type == WeightType.kilos ? 'kg' : 'lbs';
    return amount.toString() + ' ' + typeString;
  }
}