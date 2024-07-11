import 'package:equatable/equatable.dart';

abstract class CustomBracketEvent extends Equatable {
  const CustomBracketEvent();

  @override
  List<Object> get props => [];
}

class LoadCustomBracket extends CustomBracketEvent {}
