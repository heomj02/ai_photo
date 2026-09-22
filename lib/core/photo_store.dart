import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class PhotoStore {
  Future<String> save(XFile photo) async {
    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory('${documents.path}/captures');
    await directory.create(recursive: true);
    final path =
        '${directory.path}/${DateTime.now().microsecondsSinceEpoch}.jpg';
    await photo.saveTo(path);
    return path;
  }
}
