import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test20210418/bloc/test_bloc.dart';
import 'package:test20210418/bloc/test_event.dart';

import 'bloc/test_state.dart';
import 'custom_slider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => TestBloc(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _currentValue = 10;
  double _minValue = 6;
  double _maxValue = 30;

  List<Color> _colorList = [Colors.green, Colors.red, Colors.blue];

  Color _colorLine;
  Color _colorCircle;
  Color _colorText;

  int _keyLine = 0;
  int _keyCircle = 1;
  int _keyText = 2;

  @override
  void initState() {
    _colorLine = _colorList[0];
    _colorCircle = _colorList[1];
    _colorText = _colorList[2];

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild");
    return Scaffold(
        appBar: AppBar(
          title: Text("Test"),
        ),
        body: BlocListener<TestBloc, TestState>(
          listener: (context, state) {
            if (state is ChangeColorState) {
              switch (state.key) {
                case "line":
                  _colorLine = state.color;
                  break;
                case "circle":
                  _colorCircle = state.color;
                  break;
                case "text":
                  _colorText = state.color;
                  break;
              }
            }
            if (state is ChangeSliderState) {
              _currentValue = state.value;
            }
          },
          child: BlocBuilder<TestBloc, TestState>(builder: (context, state) {
            return _buildBody();
          }),
        ));
  }

  Widget _buildBody() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            (_currentValue + 1).toInt().toString(),
            style: TextStyle(color: Colors.grey, fontSize: 40),
          ),
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Row(
              children: [
                Text(
                  "Kéo/nhấn tăng/ giảm để cập nhật tuổi",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                Expanded(child: SizedBox()),
                Text(
                  "(Tuổi)",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
          _buildSlider(),
          _buildIncreaseDecrease(),
          _line(),
          _circle(),
          _text()
        ],
      ),
    );
  }

  Widget _buildSlider() {
    return Row(
      children: [
        Text(
          _minValue.toInt().toString(),
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _colorLine,
              inactiveTrackColor: Colors.blue[100],
              trackShape: RectangularSliderTrackShape(),
              trackHeight: 4.0,
              thumbColor: _colorText,
              thumbShape: CustomSliderThumbCircle(
                  thumbRadius: 25,
                  min: _minValue.toInt(),
                  max: _maxValue.toInt()),
              overlayColor: _colorLine.withAlpha(32),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            ),
            child: Slider(
              min: _minValue,
              max: _maxValue,
              value: _currentValue,
              label: '$_currentValue',
              onChanged: (value) {
                BlocProvider.of<TestBloc>(context)
                    .add(ChangeSliderEvent(value: value));
              },
            ),
          ),
        ),
        Text(_maxValue.toInt().toString(),
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildIncreaseDecrease() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              BlocProvider.of<TestBloc>(context).add(
                ChangeSliderEvent(value: --_currentValue),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Giảm",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              print("test");
              BlocProvider.of<TestBloc>(context).add(
                ChangeSliderEvent(value: ++_currentValue),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Tăng",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _line() {
    return Container(
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  color: _colorLine,
                  width: 50,
                  height: 3,
                ),
                Text(
                  ":",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ],
            ),
          ),
          _buildListColor(_keyLine, "line"),
        ],
      ),
    );
  }

  Widget _circle() {
    return Container(
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: _colorCircle,
                      ),
                      borderRadius: BorderRadius.circular(50)),
                  width: 50,
                  height: 50,
                ),
                Text(
                  ":",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ],
            ),
          ),
          _buildListColor(_keyCircle, "circle"),
        ],
      ),
    );
  }

  Widget _text() {
    return Container(
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.12,
                  margin: EdgeInsets.only(right: 10),
                  child: Text(
                    (_currentValue + 1).toInt().toString(),
                    style: TextStyle(color: _colorText, fontSize: 30),
                  ),
                ),
                Text(
                  ":",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ],
            ),
          ),
          _buildListColor(_keyText, "text"),
        ],
      ),
    );
  }

  Widget _buildListColor(int indexKey, String key) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(
            indexKey: indexKey,
            index: 0,
            color: Colors.green,
            tap: () => _tapAction(key, 0),
          ),
          _item(
              indexKey: indexKey,
              index: 1,
              color: Colors.red,
              tap: () => _tapAction(key, 1)),
          _item(
              indexKey: indexKey,
              index: 2,
              color: Colors.blue,
              tap: () => _tapAction(key, 2)),
        ],
      ),
    );
  }

  Widget _item({int indexKey, int index, Color color, Function tap}) {
    return Container(
      color: _colorList[index],
      width: 50,
      height: 50,
      child: RawMaterialButton(
        padding: EdgeInsets.zero,
        onPressed: tap,
        child: Container(
          child: Icon(
            indexKey != index ? null : Icons.check,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

  void _tapAction(String key, int index) {
    switch (key) {
      case "line":
        _keyLine = index;
        break;
      case "circle":
        _keyCircle = index;

        break;
      case "text":
        _keyText = index;

        break;
    }
    BlocProvider.of<TestBloc>(context)
        .add(ChangeColorEvent(key: key, color: _colorList[index]));
  }
}
