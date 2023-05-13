import 'package:flutter/material.dart';
import 'rowinfo.dart';

class EnumRow extends StatefulWidget {
  EnumRow(
      {required this.label,
      required this.title,
      required this.value,
      required this.options,
      this.isButton = false,
      required this.onValueChanged,
      super.key});

  final String label;
  final String title;
  Object value;
  List<Object> options;
  Function onValueChanged;
  bool isButton;

  @override
  State<EnumRow> createState() => _EnumRowState();
}

class _EnumRowState extends State<EnumRow> {
  void updateState() {
    setState(() {});
    widget.value = widget.value;
    widget.onValueChanged(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: (widget.isButton == false)
            ? RowInfo(label: widget.label, value: widget.value.toString())
            : ButtonInfo(
                label: widget.label,
              ),
        onTap: () async {
          await _dialogBuilder(
            context: context,
            title: widget.title,
            showValue: false,
            value: widget.value,
            elements: widget.options,
            callback: (option_value) {
              widget.value = option_value;
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
    required Object value,
    required List<Object> elements,
    required Function callback}) {
  Object _value = value;
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
            insetPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            title: showValue ? Text("${title}:  ${_value}") : Text("${title}"),
            content: SizedBox(
                height: 40,
                width: 1000,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < elements.length; i++) ...[
                      GestureDetector(
                        child: Container(
                          constraints:
                              BoxConstraints(minHeight: 40, minWidth: 100),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1)),
                          child: Center(
                            child: Text(
                              elements.elementAt(i).toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        onTap: () {
                          callback(elements.elementAt(i));
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ],
                )));
      });
    },
  );
}
