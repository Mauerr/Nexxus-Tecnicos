import 'package:equatable/equatable.dart';
import 'car_model.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

class HomeLoaded extends HomeState {
  final List<CarModel> cars;
  final CarModel selectedCar;

  HomeLoaded({
    required this.cars,
    required this.selectedCar,
  });

  HomeLoaded copyWith({
    List<CarModel>? cars,
    CarModel? selectedCar,
  }) {
    return HomeLoaded(
      cars: cars ?? this.cars,
      selectedCar: selectedCar ?? this.selectedCar,
    );
  }

  @override
  List<Object?> get props => [cars, selectedCar];
}
