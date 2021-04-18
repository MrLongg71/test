import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class TestState extends Equatable {
  const TestState();

  @override
  List<Object> get props => [];
}

class ChangeSliderState extends TestState {
  final double value;

  ChangeSliderState({this.value});

  @override
  List<Object> get props => [value];
}

class ChangeColorState extends TestState {
  final Color color;

  ChangeColorState({this.color});

  @override
  List<Object> get props => [color];
}
