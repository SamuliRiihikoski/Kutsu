import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kutsu/providers/dates.dart';
import 'package:kutsu/singletons/application.dart';
import 'package:kutsu/src/shared/shared.dart';
import 'package:kutsu/src/features/lists/bloc/lists_bloc.dart';

class CreateDateScreen extends StatefulWidget {
  CreateDateScreen({super.key});

  String label = "";
  String text = "";

  void addLabel(String label) {
    this.label = label;
  }

  void addText(String text) {
    this.text = text;
  }

  @override
  State<CreateDateScreen> createState() => _CreateDateScreenState();
}

class _CreateDateScreenState extends State<CreateDateScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        child: Padding(
            padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
            child: Column(
              children: [
                const Text(
                  'Luo uusi kutsu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Container(
                    height: 1,
                    color: Color.fromARGB(255, 80, 80, 80),
                  ),
                ),
                if (widget.label.length > 0) ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Otsikko',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
                TextRow(
                  title: 'Kirjoita otsikko',
                  boxText: "Kirjoita otsikko",
                  maxLength: 40,
                  maxRows: 1,
                  value: widget.label,
                  onValueChanged: (value) {
                    setState(() {
                      widget.label = value;
                    });
                  },
                ),
                if (widget.text.length > 0) ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Lyhyt kuvaus',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
                TextRow(
                  title: 'Kirjoita lyhyt kuvaus',
                  boxText: "Kirjoita lyhyt kuvas",
                  value: widget.text,
                  maxRows: 1,
                  maxLength: 100,
                  onValueChanged: (value) {
                    setState(() {
                      widget.text = value;
                    });
                  },
                ),
                Spacer(),
                if (widget.label.length > 0 && widget.text.length > 0) ...[
                  SizedBox(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 106, 106, 106),
                                      width: 1),
                                ),
                                child: const Center(
                                    child: Text(
                                  'Takaisin',
                                  style: TextStyle(fontSize: 20),
                                )),
                              ),
                            ),
                            onTap: () {
                              context.pop();
                            },
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Color.fromARGB(255, 106, 106, 106),
                                      width: 1),
                                ),
                                child: const Center(
                                    child: Text(
                                  'Luo Kutsu',
                                  style: TextStyle(fontSize: 20),
                                )),
                              ),
                            ),
                            onTap: () async {
                              Application().changeTabIndex = 1;
                              final date = await context
                                  .read<DatesProvider>()
                                  .addDate(
                                      label: widget.label, text: widget.text);
                              context
                                  .read<ListBloc>()
                                  .add(AddInvitation(date: date));
                              context.pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ] else ...[
                  SizedBox(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 106, 106, 106),
                                      width: 1),
                                ),
                                child: const Center(
                                    child: Text(
                                  'Takaisin',
                                  style: TextStyle(fontSize: 20),
                                )),
                              ),
                            ),
                            onTap: () {
                              context.pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ],
            )),
        onTap: () {
          context.pop();
        },
      ),
    );
  }
}
