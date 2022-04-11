import 'dart:convert';
import 'meal_item.dart';

ResponseFilter responseFilterFromJson(String string) =>
    ResponseFilter.fromJson(json.decode(string));

String responseFilterFilterToJson(ResponseFilter data) => json.encode(data);

class ResponseFilter {
  ResponseFilter({
    required this.meals,
  });

  List<Meal>? meals;

  factory ResponseFilter.fromJson(Map<String, dynamic> json) => ResponseFilter(
      meals: List<Meal>.from(json["meals"].map((e) => Meal.fromJson(e))));

  //tambahin map to json nanti

  Map<String, dynamic> toJson() =>
      {"meals": List<dynamic>.from(meals!.map((e) => e.toJson()))};
}
