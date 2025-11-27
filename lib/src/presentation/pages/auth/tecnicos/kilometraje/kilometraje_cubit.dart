import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/kilometraje/kilometraje_state.dart';


class EvidenciaKilometrajeCubit extends Cubit<EvidenciaKilometrajeState> {
  final ImagePicker _picker = ImagePicker();

  EvidenciaKilometrajeCubit() : super(const EvidenciaKilometrajeState());

  Future<void> tomarFotoKmInicio() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) emit(state.copyWith(fotoKmInicio: File(image.path)));
  }

  Future<void> tomarFotoKmFin() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) emit(state.copyWith(fotoKmFin: File(image.path)));
  }

  Future<void> tomarFotoAsientosDel() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) emit(state.copyWith(fotoAsientosDel: File(image.path)));
  }

  Future<void> tomarFotoAsientosTras() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) emit(state.copyWith(fotoAsientosTras: File(image.path)));
  }
}
