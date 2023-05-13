import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kutsu/providers/rooms.dart';
import 'package:kutsu/providers/users.dart';
import 'package:kutsu/src/features/chat/chat.dart';
import 'dart:async';
import '../../../../extensions.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({required this.roomID, required this.roomError, super.key});

  List<Message> messages = [];
  String roomID;
  String friendID = "";
  String userID = "";
  int messageCursor = 0;
  Function roomError;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void initState() {
    _inputController.addListener(() {});
  }

  void updateList() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc()..add(FetchMessages()),
      child: BlocConsumer<ChatBloc, ChatState>(listener: (context, state) {
        if (state.action == ListState.updated) {
          updateList();
        }
      }, builder: (context, state) {
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('rooms')
              .doc(widget.roomID)
              .snapshots(),
          builder: (context, snapshot) {
            widget.messages.clear();
            if (snapshot.hasData) {
              if (snapshot.data!.data() == null) {
                return const Center(
                  child: Text('Ystäväsi on poistunut huoneesta'),
                );
              } else {
                final room = snapshot.data!.data() as Map<String, dynamic>;

                final ff = List.from(room['messages']);
                widget.friendID = room['friendID'] as String;
                widget.userID = room['userID'] as String;

                //final messages =
                //    room.values.expand((element) => element).toList();

                for (final item in ff) {
                  item.forEach((key, value) {
                    widget.messages.add(Message(userID: key, message: value));
                  });
                }
                updateList();
              }

              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Column(
                  children: [
                    SizedBox(
                        height: 30,
                        child: MembersLabel(
                            friendID: (FirebaseAuth.instance.currentUser!.uid ==
                                    widget.userID)
                                ? widget.friendID
                                : widget.userID)),
                    Expanded(
                      flex: 10,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(0),
                        itemCount: widget.messages.length,
                        itemBuilder: (context, index) {
                          Message msg = widget.messages.elementAt(index);
                          return Row(
                            mainAxisAlignment:
                                (FirebaseAuth.instance.currentUser!.uid !=
                                        msg.userID)
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: GestureDetector(
                                  child: Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 300),
                                    decoration: BoxDecoration(
                                        color: (FirebaseAuth.instance
                                                    .currentUser!.uid !=
                                                msg.userID)
                                            ? const Color.fromARGB(
                                                255, 213, 234, 226)
                                            : const Color.fromARGB(
                                                255, 207, 221, 240),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          msg.message,
                                          style: context.labelLarge!.copyWith(
                                            fontSize: 17,
                                          ),
                                        )),
                                  ),
                                  onTap: () {
                                    _scrollController.jumpTo(_scrollController
                                        .position.maxScrollExtent);
                                  },
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    TextField(
                      controller: _inputController,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 194, 194, 194),
                              width: 2.0),
                        ),
                      ),
                      onSubmitted: (value) {
                        if (_inputController.text != "") {
                          context
                              .read<RoomsProvider>()
                              .addMessage(widget.roomID, _inputController.text);

                          _inputController.text = "";
                        }
                      },
                    ),
                  ],
                ),
              );
            }
            return Text('snapshot.error errori');
          },
        );
      }),
    );
  }
}

class MembersLabel extends StatelessWidget {
  const MembersLabel({required this.friendID, super.key});

  final String friendID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UsersProvider().getUser(friendID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 5, 2),
                child: Row(children: [
                  Text(
                    '${snapshot.data!.name}, ${snapshot.data!.age}',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  const Text(
                    'Minä',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
              Container(
                color: Color.fromARGB(255, 93, 93, 93),
                height: 1,
              ),
            ],
          );
        }
        return const Center(
          child: Text('Loading'),
        );
      },
    );
  }
}
