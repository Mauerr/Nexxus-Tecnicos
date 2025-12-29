import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'evidenciaTapiceria_state.dart';

class EvidenciaTapiceriaCubit extends Cubit<EvidenciaTapiceriaState> {
  EvidenciaTapiceriaCubit() : super(const EvidenciaTapiceriaState());

  final ImagePicker _picker = ImagePicker();

  Future<void> tomarFotoAsientosDelanteros() async {
    final XFile? photo =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 75);

    if (photo != null) {
      emit(state.copyWith(fotoAsientosDelanteros: File(photo.path)));
    }
  }

  Future<void> tomarFotoAsientosTraseros() async {
    final XFile? photo =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 75);

    if (photo != null) {
      emit(state.copyWith(fotoAsientosTraseros: File(photo.path)));
    }
  }

  Future<void> tomarFotoTablero() async {
    final XFile? photo =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 75);

    if (photo != null) {
      emit(state.copyWith(fotoTablero: File(photo.path)));
    }
  }
}