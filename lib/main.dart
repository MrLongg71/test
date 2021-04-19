import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test20210418/bloc/test_bloc.dart';
import 'package:test20210418/bloc/test_event.dart';
import 'package:test20210418/model.dart';

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
  double _value = 0.0;
  List<Color> _colorList = [Colors.green, Colors.red, Colors.blue];
  List<Model> model = [];
  Color _colorLine;
  Color _colorCircle;
  Color _colorText;
  int _keyLine = -1;

  @override
  void initState() {
    _colorLine = _colorList[0];
    _colorCircle = _colorList[0];
    _colorText = _colorList[0];

    // model.add(Model(color:));

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
        body: BlocListener<TestBloc, TestState>(
      listener: (context, state) {
        if (state is ChangeColorState) {
          _colorLine = state.color;
        }
        if (state is ChangeSliderState) {
          _value = state.value;
        }
      },
      child: BlocBuilder<TestBloc, TestState>(builder: (context, state) {
        return _buildBody();
      }),
    ));
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: _colorLine,
            inactiveTrackColor: Colors.red[100],
            trackShape: RectangularSliderTrackShape(),
            trackHeight: 4.0,
            thumbColor: _colorText,
            thumbShape: CustomSliderThumbCircle(thumbRadius: 25, min: 0, max: 100),
            overlayColor: _colorLine.withAlpha(32),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
          ),
          child: Slider(
            min: 0,
            max: 100,
            value: _value,
            label: '$_value',
            onChanged: (value) {
              BlocProvider.of<TestBloc>(context).add(ChangeSliderEvent(value: value));
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
                child: Text("Giảm"),
                onPressed: () {
                  setState(() {
                    _value--;
                  });
                }),
            RaisedButton(
                child: Text("Tăng"),
                onPressed: () {
                  setState(() {
                    _value++;
                  });
                })
          ],
        ),
        _buildLineColor(),
        _buildCircleColor(),
        _buildTextColor(),
        _line(),
      ],
    );
  }

  Widget _buildLineColor() {
    return Container(
      height: 50,
      child: Row(
        children: [
          Container(
            color: _colorLine,
            width: 50,
            height: 3,
          ),
          Text(
            ":",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _colorList.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  BlocProvider.of<TestBloc>(context)
                      .add(ChangeColorEvent(color: _colorList[index]));
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  color: _colorList[index],
                  width: 50,
                  height: 50,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildCircleColor() {
    return Container(
      height: 50,
      child: Row(
        children: [
          Container(
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
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _colorList.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  _colorCircle = _colorList[index];
                  setState(() {});
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  color: _colorList[index],
                  width: 40,
                  height: 60,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildTextColor() {
    bool _check = true;
    return Container(
      height: 50,
      child: Row(
        children: [
          Text(
            (_value + 1).toInt().toString(),
            style: TextStyle(color: _colorText),
          ),
          Text(
            ":",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _colorList.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    _check = !_check;
                    _colorText = _colorList[index];
                    print(_check);
                    setState(() {});
                  },
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        color: _colorList[index],
                        width: 50,
                        height: 50,
                      ),
                      _check
                          ? Align(
                              child: Icon(
                                Icons.check,
                                size: 30.0,
                                color: Colors.white,
                              ),
                              alignment: Alignment.center,
                            )
                          : Container()
                    ],
                  ));
            },
          )
        ],
      ),
    );
  }

  Widget _line() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Container(
            child: Text('Line'),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _item(indexKey: _keyLine, index: 0, color: Colors.green, tap: () => _tapLine(0)),
                _item(indexKey: _keyLine, index: 1, color: Colors.green, tap: () => _tapLine(1)),
                _item(indexKey: _keyLine, index: 2, color: Colors.green, tap: () => _tapLine(2)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _item({int indexKey, int index, Color color, Function tap}) {
    return Container(
      width: 40,
      height: 40,
      child: RawMaterialButton(
        padding: EdgeInsets.zero,
        onPressed: tap,
        child: Container(
          child: Icon(
            indexKey != index ? Icons.check_box_outline_blank : Icons.check_box,
            color: color,
            size: 30,
          ),
        ),
      ),
    );
  }

  void _tapLine(int index) {
    setState(() {
      _keyLine = index;
    });
  }
}
