import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class CustomImageProvider extends ChangeNotifier{
  File? _selectedImage;
  bool _uploadingImage = false;
  String _imageName = '';

  File? get selectedImage => _selectedImage;
  bool get uploadingImage => _uploadingImage;
  String get imageName => _imageName;

  Future pickImageFromGallery() async {
    final returnedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    _selectedImage = File(returnedImage!.path);
    _imageName = returnedImage.name;
    notifyListeners();
  }

  Future pickImageFromCamera() async {
    final returnedImage =
    await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    _selectedImage = File(returnedImage!.path);
    notifyListeners();
  }
}