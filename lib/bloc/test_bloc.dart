import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test20210418/bloc/test_event.dart';
import 'package:test20210418/bloc/test_state.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  TestBloc() : super(null);

  @override
  Stream<TestState> mapEventToState(TestEvent event) async* {
    if (event is ChangeColorEvent) {
      yield ChangeColorState(color: event.color);
    }
    if (event is ChangeSliderEvent) {
      yield ChangeSliderState(value: event.value);
    }
  }
}
