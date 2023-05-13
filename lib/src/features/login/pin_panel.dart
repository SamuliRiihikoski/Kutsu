import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:core';

import 'package:kutsu/src/features/login/login_screen.dart';

class PinPanel extends StatefulWidget {
  PinPanel({required this.callback, super.key});

  int currentIndex = 0;
  Function callback;
  List<String> digits = List<String>.filled(6, "");

  @override
  State<PinPanel> createState() => _PinPanelState();
}

class _PinPanelState extends State<PinPanel> {
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.backspace): MoveFocusBackIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          MoveFocusBackIntent: MoveFocusBack(
            () {
              setState(() {
                widget.currentIndex--;
              });
            },
          )
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < 6; i++) ...[
                    PinNumber(
                      value: widget.digits[i],
                      active: (widget.currentIndex == i),
                      callback: (value) {
                        setState(() {
                          widget.digits[i] = value;
                          widget.currentIndex++;
                        });
                      },
                      tabCallback: () {
                        setState(() {
                          widget.currentIndex = i;
                          for (int index = i;
                              index < widget.digits.length;
                              index++) {
                            widget.digits[index] = "";
                          }
                        });
                      },
                    ),
                  ]
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color.fromARGB(255, 163, 163, 163),
                      width: 1),
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Varmista koodi',
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  onTap: () {
                    String code = "";
                    for (final item in widget.digits) {
                      code += item.toString();
                    }
                    print(code);
                    widget.callback(code);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PinNumber extends StatefulWidget {
  PinNumber(
      {required this.value,
      required this.active,
      required this.callback,
      required this.tabCallback,
      super.key});

  final bool active;
  String value = "";
  Function callback;
  Function tabCallback;

  @override
  State<PinNumber> createState() => _PinNumberState();
}

class _PinNumberState extends State<PinNumber> {
  FocusNode focusNode = FocusNode();
  TextEditingController _controller = TextEditingController();

  void initState() {
    widget.active ? focusNode.requestFocus() : null;
    _controller.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: widget.active
            ? Color.fromARGB(255, 255, 255, 255)
            : Color.fromARGB(255, 224, 224, 224),
        border: Border.all(
          color: Color.fromARGB(255, 161, 161, 161),
          width: 1,
        ),
      ),
      child: TextField(
        focusNode: focusNode,
        controller: _controller,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(fontSize: 35),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            counterStyle: TextStyle(height: double.minPositive),
            counterText: ""),
        onChanged: (value) {
          setState(() {});
          focusNode.nextFocus();
          widget.callback(value);
        },
        onTap: () {
          _controller.clear();
          widget.tabCallback();
          print('TAP');
        },
      ),
    );
  }
}

class MoveFocusBackIntent extends Intent {
  const MoveFocusBackIntent();
}

class MoveFocusBack extends Action<MoveFocusBackIntent> {
  MoveFocusBack(this.callback);

  VoidCallback callback;

  @override
  void invoke(MoveFocusBackIntent intent) {
    callback();
    print('My first action:');
  }
}
