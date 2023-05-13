import 'package:flutter/material.dart';

class LabelRow extends StatefulWidget {
  LabelRow(
      {required this.title,
      required this.value,
      required this.onValueChanged,
      super.key});

  final String title;
  String value;
  Function onValueChanged;

  @override
  State<LabelRow> createState() => _LabelRowState();
}

class _LabelRowState extends State<LabelRow> {
  void updateState() {
    setState(() {});
    widget.value = widget.value;
    widget.onValueChanged(widget.value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(children: [
        Center(
          child: GestureDetector(
            child: Text(
              widget.value,
              style: const TextStyle(
                  color: Color.fromARGB(255, 43, 43, 43),
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
            ),
            onTap: () async {
              await _dialogBuilder(
                context: context,
                title: widget.title,
                value: widget.value,
                callback: (value) {
                  widget.value = value;
                },
              ).then((value) {
                updateState();
              });
            },
          ),
        )
      ]),
    );
  }
}

Future<void> _dialogBuilder(
    {required BuildContext context,
    required String title,
    required String value,
    required Function callback}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        TextEditingController _controller = TextEditingController();
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 219, 219, 219),
          buttonPadding: EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5))),
          alignment: Alignment.bottomCenter,
          insetPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          title: Text("${title}"),
          content: SizedBox(
            height: 80,
            width: 1000,
            child: TextFormField(
              controller: TextEditingController()..text = value,
              onChanged: (value) {
                print(value);
                callback(value);
              },
              minLines: 1,
              maxLines: null,
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
