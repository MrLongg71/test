import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class TestEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class ChangeSliderEvent extends TestEvent {
  final double value;

  ChangeSliderEvent({this.value});

  @override
  List<Object> get props => [value];
}


class ChangeColorEvent extends TestEvent {
  final String key;
  final Color color;


  ChangeColorEvent({this.key,this.color});

  @override
  List<Object> get props => [key,color];
}
