import 'package:flutter_application_8/models/Users.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

class Configure {
  static const server = "localhost:3000";
  static Users login = Users();
  

  static Future<String> getProductJsonPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/product.json';
  }


  static Future<void> initLocalProductJson() async {
    final path = await getProductJsonPath();
    if (!(await File(path).exists())) {
      final data = await rootBundle.loadString('assets/data/product.json');
      await File(path).writeAsString(data);
    }
  }
}
