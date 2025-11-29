import 'package:bloc/bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'evidenciaHojalateria_state.dart';

class EvidenciaHojalateriaCubit extends Cubit<EvidenciaHojalateriaState> {
  final ImagePicker _picker = ImagePicker();

  EvidenciaHojalateriaCubit() : super(EvidenciaHojalateriaState());

  Future<void> tomarFotoFrente() async {
    final XFile? foto = await _picker.pickImage(source: ImageSource.camera);
    if (foto == null) return;

    emit(state.copyWith(fotoFrente: File(foto.path)));
  }

  Future<void> tomarFotoIzquierdo() async {
    final XFile? foto = await _picker.pickImage(source: ImageSource.camera);
    if (foto == null) return;

    emit(state.copyWith(fotoIzquierdo: File(foto.path)));
  }

  Future<void> tomarFotoDerecho() async {
    final XFile? foto = await _picker.pickImage(source: ImageSource.camera);
    if (foto == null) return;

    emit(state.copyWith(fotoDerecho: File(foto.path)));
  }

  Future<void> tomarFotoReverso() async {
    final XFile? foto = await _picker.pickImage(source: ImageSource.camera);
    if (foto == null) return;

    emit(state.copyWith(fotoReverso: File(foto.path)));
  }

  Future<void> guardarValidacion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("hojalateria_ok", true);
  }
}
