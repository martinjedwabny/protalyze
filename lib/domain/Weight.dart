enum WeightType {
  kilos,
  pounds
}

class Weight {
  final int amount;
  final WeightType type;
  Weight(this.amount, this.type);
}