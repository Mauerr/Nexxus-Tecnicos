import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'evidenciaMecanica_state.dart';

class EvidenciaMecanicaCubit extends Cubit<EvidenciaMecanicaState> {
  EvidenciaMecanicaCubit() : super(const EvidenciaMecanicaState());

  final ImagePicker _picker = ImagePicker();

  Future<void> tomarFotoAceite() async {
    final XFile? photo =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 75);

    if (photo != null) {
      emit(state.copyWith(fotoAceite: File(photo.path)));
    }
  }

  Future<void> tomarFotoFrenos() async {
    final XFile? photo =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 75);

    if (photo != null) {
      emit(state.copyWith(fotoFrenos: File(photo.path)));
    }
  }

  Future<void> tomarFotoAnticongelante() async {
    final XFile? photo =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 75);

    if (photo != null) {
      emit(state.copyWith(fotoAnticongelante: File(photo.path)));
    }
  }
}
