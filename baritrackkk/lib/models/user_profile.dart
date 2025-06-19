class UserProfile {
  DateTime? surgeryDate;
  String? sex;
  int? age;
  double? weight;
  double? height;
  String? race;
  String? surgeryType;
  double? startingWeight;
  String? name;
  String? email;

  UserProfile({
    this.surgeryDate,
    this.sex,
    this.age,
    this.weight,
    this.height,
    this.race,
    this.surgeryType,
    this.startingWeight,
    this.name,
    this.email,
  });

  double get bmi {
    if (weight == null || height == null) return 0;
    // Convert height from cm to m
    double heightInM = height! / 100;
    return weight! / (heightInM * heightInM);
  }

  int get weeksPostOp {
    if (surgeryDate == null) return 0;
    final difference = DateTime.now().difference(surgeryDate!);
    return (difference.inDays / 7).floor();
  }

  double getExpectedWeight(int weeks) {
    if (startingWeight == null || surgeryType == null) return weight ?? 0;

    double percentageLoss = 0;

    // Calculate based on weeks
    switch (surgeryType) {
      case 'Gastric Bypass':
        if (weeks <= 4) percentageLoss = 0.10;
        else if (weeks <= 12) percentageLoss = 0.25;
        else if (weeks <= 24) percentageLoss = 0.50;
        else percentageLoss = 0.60;
        break;
      case 'Gastric Sleeve':
        if (weeks <= 4) percentageLoss = 0.08;
        else if (weeks <= 12) percentageLoss = 0.20;
        else if (weeks <= 24) percentageLoss = 0.45;
        else percentageLoss = 0.55;
        break;
      case 'Duodenal Switch':
        if (weeks <= 4) percentageLoss = 0.12;
        else if (weeks <= 12) percentageLoss = 0.35;
        else if (weeks <= 24) percentageLoss = 0.70;
        else percentageLoss = 0.80;
        break;
    }

    return startingWeight! * (1 - percentageLoss);
  }

  Map<String, dynamic> toJson() => {
    'surgeryDate': surgeryDate?.toIso8601String(),
    'sex': sex,
    'age': age,
    'weight': weight,
    'height': height,
    'race': race,
    'surgeryType': surgeryType,
    'startingWeight': startingWeight,
    'name': name,
    'email': email,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      surgeryDate: json['surgeryDate'] != null ? DateTime.parse(json['surgeryDate']) : null,
      sex: json['sex'],
      age: json['age'],
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
      race: json['race'],
      surgeryType: json['surgeryType'],
      startingWeight: json['startingWeight']?.toDouble(),
      name: json['name'],
      email: json['email'],
    );
  }
}