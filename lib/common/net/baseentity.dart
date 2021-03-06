import 'package:back/Pages/dio.dart';

class BaseEntity<T> {
  int code;
  String message;
  T data;

  BaseEntity({required this.code, required this.message, required this.data});

  factory BaseEntity.fromJson(json) {
    return BaseEntity(
      code: json['code'],
      message: json['message'],
      data: EntityFactory.generateOBJ<T>(json['data']),
    );
  }
}

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (T.toString() == 'TestEntity') {
      return TestEntity.fromJson(json) as T;
    } else {
      return json as T;
    }
  }
}

class ErrorEntity {
  int code;
  String message;

  ErrorEntity({required this.code, required this.message});
}
