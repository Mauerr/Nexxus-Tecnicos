import 'package:image_picker/image_picker.dart';

class CamaraService {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> tomarFoto() async {
    final foto = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,   // Reduce peso, mantiene calidad decente
      preferredCameraDevice: CameraDevice.rear,
    );

    return foto;
  }
}
