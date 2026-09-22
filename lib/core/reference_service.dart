import 'package:image_picker/image_picker.dart';

/// Keeps the system photo picker outside screen code.
class ReferenceService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pick() => _picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 2048,
    maxHeight: 2048,
    requestFullMetadata: false,
  );

  Future<XFile?> recover() async {
    final response = await _picker.retrieveLostData();
    if (response.exception != null) throw response.exception!;
    final files = response.files;
    return files == null || files.isEmpty ? null : files.first;
  }
}
