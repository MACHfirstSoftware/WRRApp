import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisconsin_app/models/response_error.dart';
import 'package:wisconsin_app/utils/exceptions/network_exceptions.dart';

part 'api_result.freezed.dart';

@freezed
abstract class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success({required T data}) = Success<T>;

  const factory ApiResult.failure({required NetworkExceptions error}) =
      Failure<T>;
  const factory ApiResult.responseError(
      {required ResponseError responseError}) = Error<T>;
}
