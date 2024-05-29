import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomUser extends Equatable {
  final String? username;
  final String? pfp;
  final int age;

  const CustomUser({
    this.username,
    this.pfp,
    required this.age,
  });
  
  @override
  List<Object?> get props => [username, pfp, age];

  CustomUser copyWith({
    String? username,
    String? pfp,
    int? age,
  }) {
    return CustomUser(
      username: username ?? this.username,
      pfp: pfp ?? this.pfp,
      age: age ?? this.age,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'pfp': pfp,
      'age': age,
    };
  }

  factory CustomUser.fromMap(Map<String, dynamic> map) {
    return CustomUser(
      username: map['username'],
      pfp: map['pfp'],
      age: map['age']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomUser.fromJson(String source) => CustomUser.fromMap(json.decode(source));

  @override
  String toString() => 'CustomUser(username: $username, pfp: $pfp, age: $age)';
}
