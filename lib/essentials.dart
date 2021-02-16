import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

Box globalBox;

Future<void> hiveSetup() async {
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  globalBox = await Hive.openBox('nodeBox');
}

Widget vSpace(k) {
  return SizedBox(height: k * 1.0);
}

List dummyList = [
  { "path":"/data","key":"data","value":null},
];