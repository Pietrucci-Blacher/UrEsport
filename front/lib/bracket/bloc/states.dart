import 'package:equatable/equatable.dart';
import 'package:uresport/bracket/models/poule.dart';

abstract class PouleState extends Equatable {
  const PouleState();

  @override
  List<Object> get props => [];
}

class PouleInitial extends PouleState {}

class PouleLoading extends PouleState {}

class PouleLoaded extends PouleState {
  final List<Poule> poules;

  const PouleLoaded(this.poules);

  @override
  List<Object> get props => [poules];
}

class PouleError extends PouleState {
  final String message;

  const PouleError(this.message);

  @override
  List<Object> get props => [message];
}
