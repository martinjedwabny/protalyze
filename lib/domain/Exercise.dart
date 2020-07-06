class Exercise {
  final String name;
  Exercise(this.name);

  Exercise.fromJson(Map<String, dynamic> json)
    : name = json['name'];

  Map<String, dynamic> toJson() =>
    {
      'name' : name
    };
}


