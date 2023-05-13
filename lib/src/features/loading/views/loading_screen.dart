import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kutsu/src/features/loading/bloc/loading_bloc.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final _items = [];
  final GlobalKey<AnimatedListState> _key = GlobalKey();

  void _addItem(String message) {
    _items.insert(0, "${message}");
    _key.currentState
        ?.insertItem(0, duration: const Duration(milliseconds: 200));
  }

  void _clearItems() {
    _items.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoadingBloc, LoadingState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (!state.message.isEmpty) {
              _addItem(state.message);
            }
            return Column(
              children: [
                Expanded(
                  child: Container(
                      color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.9),
                      child: Column(
                        children: [
                          const Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(60),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: CircularProgressIndicator(
                                    color: Color.fromARGB(255, 59, 71, 106)),
                              ),
                            ),
                          ),
                          Flexible(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: AnimatedList(
                                  key: _key,
                                  initialItemCount: _items.length,
                                  padding: const EdgeInsets.all(2),
                                  itemBuilder: (context, index, animation) {
                                    return SizeTransition(
                                      key: UniqueKey(),
                                      axisAlignment: 2.0,
                                      sizeFactor: animation,
                                      child: Padding(
                                        padding: (index == 0)
                                            ? const EdgeInsets.all(20)
                                            : const EdgeInsets.all(5),
                                        child: Center(
                                          child: Text(
                                            _items[index],
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: (index == 0)
                                                    ? const Color.fromARGB(
                                                        255, 209, 209, 209)
                                                    : (index < 6)
                                                        ? const Color.fromARGB(
                                                            255, 78, 78, 78)
                                                        : const Color.fromARGB(
                                                            0, 209, 209, 209)),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ))
                        ],
                      )),
                ),
              ],
            );
          }),
    );
  }
}
