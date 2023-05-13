import 'package:flutter/material.dart';

class TextRow extends StatefulWidget {
  TextRow(
      {required this.title,
      required this.value,
      required this.onValueChanged,
      this.maxLength = 200,
      this.maxRows = 4,
      this.isEditable = true,
      this.boxText = "Kerro lyhyesti itsestäsi",
      super.key});

  final String title;
  String value;
  Function onValueChanged;
  final bool isEditable;
  final String boxText;
  final int maxLength;
  final int maxRows;

  @override
  State<TextRow> createState() => _TextRowState();
}

class _TextRowState extends State<TextRow> {
  void updateState() {
    setState(() {});
    widget.value = widget.value;
    widget.onValueChanged(widget.value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(11, 5, 20, 5),
      child: Column(children: [
        if (widget.value.isEmpty) ...[
          GestureDetector(
            child: SizedBox(
              height: 50,
              width: 1000,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    width: 1,
                    color: const Color.fromARGB(255, 66, 66, 66),
                  ),
                ),
                child: Center(
                    child: Text(
                  widget.boxText,
                  style: const TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 117, 117, 117)),
                )),
              ),
            ),
            onTap: () async {
              if (!widget.isEditable) return;

              await _dialogBuilder(
                context: context,
                title: widget.title,
                value: widget.value,
                maxLength: widget.maxLength,
                maxRows: widget.maxRows,
                callback: (value) {
                  widget.value = value;
                },
              ).then((value) {
                updateState();
              });
            },
          )
        ] else ...[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  widget.value,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            onTap: () async {
              if (!widget.isEditable) return;

              await _dialogBuilder(
                context: context,
                title: widget.title,
                value: widget.value,
                maxLength: widget.maxLength,
                maxRows: widget.maxRows,
                callback: (value) {
                  widget.value = value;
                },
              ).then((value) {
                updateState();
              });
            },
          ),
        ]
      ]),
    );
  }
}

Future<void> _dialogBuilder(
    {required BuildContext context,
    required String title,
    required String value,
    required int maxLength,
    required int maxRows,
    required Function callback}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        TextEditingController _controller = TextEditingController();
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 219, 219, 219),
          buttonPadding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5))),
          alignment: Alignment.bottomCenter,
          insetPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          title: Text(title),
          content: SizedBox(
            height: 100,
            width: 1000,
            child: TextFormField(
              maxLength: maxLength,
              controller: TextEditingController()..text = value,
              onChanged: (value) {
                print(value);
                callback(value);
              },
              minLines: 1,
              maxLines: maxRows,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                  labelText: '',
                  labelStyle: TextStyle(fontSize: 19)),
            ),
          ),
        );
      });
    },
  );
}
