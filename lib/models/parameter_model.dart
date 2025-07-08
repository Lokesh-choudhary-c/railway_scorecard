class ParameterModel {
  String title;
  int score;
  String? remarks;

  ParameterModel({
    required this.title,
    this.score = 0,
    this.remarks,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'score': score,
        'remarks': remarks,
      };

  factory ParameterModel.fromJson(Map<String, dynamic> json) {
    return ParameterModel(
      title: json['title'],
      score: json['score'],
      remarks: json['remarks'],
    );
  }
}
