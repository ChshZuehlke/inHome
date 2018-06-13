import 'package:flutter/material.dart';
import 'package:in_home/app.dart';
import 'package:in_home/data/WallRepositoryMock.dart';

void main() {
  runApp(
    InHomeApp(
      homeRepository: HomeRepositoryMock(),
    ),
  );
}


