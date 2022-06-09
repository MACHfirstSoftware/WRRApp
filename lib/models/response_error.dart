import 'dart:convert';

ResponseError responseErrorFromJson(String str) =>
    ResponseError.fromJson(json.decode(str));

String responseErrorToJson(ResponseError data) => json.encode(data.toJson());

class ResponseError {
  ResponseError({
    required this.error,
    required this.errorCode,
  });

  String error;
  int errorCode;

  factory ResponseError.fromJson(Map<String, dynamic> json) => ResponseError(
        error: json["error"],
        errorCode: json["errorCode"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "errorCode": errorCode,
      };
}
