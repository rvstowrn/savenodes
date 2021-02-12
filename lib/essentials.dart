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

Map findMapParent(Map dataMap, List path) {
  Map parent = dataMap;
  path.forEach((key) => parent = parent[key]);
  return parent;
}



Map flattenMap(Map dataMap) {
  Map flatMap = new Map();
  
  void func(Map main,String key, String path) {
    String currentPath = path+"/"+key; 
    if (main[key] is String) {
      flatMap[currentPath] = main[key];
    } 
    else{ 
      if (key != "data") {
        flatMap[currentPath] = main[key];
      }
      main[key].forEach((k, v) {
        func(main[key], k, currentPath);
      });
    }
  }
  func(dataMap,"data","");
  return flatMap;
}

