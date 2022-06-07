import 'dart:convert';

List<Question> questionFromJson(String str) =>
    List<Question>.from(json.decode(str).map((x) => Question.fromJson(x)));

String questionToJson(List<Question> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Question {
  Question({
    required this.id,
    required this.prompt,
    this.description,
    this.imageLocation,
    required this.sortOrder,
    required this.answer,
  });

  int id;
  String prompt;
  dynamic description;
  dynamic imageLocation;
  int sortOrder;
  List<Answer> answer;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        prompt: json["prompt"],
        description: json["description"],
        imageLocation: json["imageLocation"],
        sortOrder: json["sortOrder"],
        answer:
            List<Answer>.from(json["answer"].map((x) => Answer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "prompt": prompt,
        "description": description,
        "imageLocation": imageLocation,
        "sortOrder": sortOrder,
        "answer": List<dynamic>.from(answer.map((x) => x.toJson())),
      };
}

class Answer {
  Answer({
    required this.id,
    required this.optionValue,
    this.description,
    this.imageLocation,
    required this.sortOrder,
  });

  int id;
  String optionValue;
  dynamic description;
  dynamic imageLocation;
  int sortOrder;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        id: json["id"],
        optionValue: json["optionValue"],
        description: json["description"],
        imageLocation: json["imageLocation"],
        sortOrder: json["sortOrder"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "optionValue": optionValue,
        "description": description,
        "imageLocation": imageLocation,
        "sortOrder": sortOrder,
      };
}
