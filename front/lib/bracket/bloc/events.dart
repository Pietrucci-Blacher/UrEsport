import 'package:equatable/equatable.dart';

abstract class PouleEvent extends Equatable {
  const PouleEvent();

  @override
  List<Object> get props => [];
}

class LoadPoules extends PouleEvent {}