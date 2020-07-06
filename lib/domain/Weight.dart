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

  Weight.fromJson(Map<String, dynamic> json) : 
    amount = json['amount'],
    type = json['type'] == 'kg' ? WeightType.kilos : WeightType.pounds;

  Map<String, dynamic> toJson() => {
    'amount' : amount,
    'type' : type == WeightType.kilos ? 'kg' : 'lbs',
  };
}