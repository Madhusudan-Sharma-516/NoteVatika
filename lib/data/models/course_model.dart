import 'package:flutter/material.dart';

class CourseModel {
  final String id;
  final String name;
  final String fullName;
  final Color color;
  final String icon;

  CourseModel({
    required this.id,
    required this.name,
    required this.fullName,
    required this.color,
    required this.icon,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      fullName: json['fullName'] as String,
      color: _parseColor(json['color'] as String),
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'fullName': fullName,
    'color': '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}',
    'icon': icon,
  };

  static Color _parseColor(String hexString) {
    final hex = hexString.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
