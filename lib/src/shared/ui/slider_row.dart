import 'package:flutter/material.dart';
import 'rowinfo.dart';

class SliderRow extends StatefulWidget {
  SliderRow(
      {required this.label,
      required this.title,
      required this.min,
      required this.max,
      required this.value,
      required this.onValueChanged,
      super.key});

  final String label;
  String title;
  final double min;
  final double max;
  int value;
  Function onValueChanged;

  @override
  State<SliderRow> createState() => _SliderRowState();
}

class _SliderRowState extends State<SliderRow> {
  void updateState() {
    setState(() {});
    widget.value = widget.value.toInt();
    widget.onValueChanged(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: RowInfo(label: widget.label, value: widget.value.toString()),
        onTap: () async {
          await _dialogBuilder(
            context: context,
            title: widget.title,
            showValue: true,
            min: widget.min,
            max: widget.max,
            value: widget.value,
            callback: (sliderValue) {
              widget.value = sliderValue.toInt();
            },
          ).then((val) => updateState());
        },
      ),
    );
  }
}

Future<void> _dialogBuilder(
    {required BuildContext context,
    required String title,
    required bool showValue,
    required double min,
    required double max,
    required int value,
    required Function callback}) {
  double _value = value.toDouble();
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 219, 219, 219),
            buttonPadding: EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5))),
            alignment: Alignment.bottomCenter,
            insetPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            title:
                showValue ? Text("$title:  ${_value.toInt()}") : Text("$title"),
            content: SizedBox(
                height: 40,
                width: 1000,
                child: Slider(
                  min: min,
                  max: max,
                  value: _value,
                  onChanged: (slider_value) {
                    setState(() => _value = slider_value);
                    callback(_value);
                  },
                )));
      });
    },
  );
}
