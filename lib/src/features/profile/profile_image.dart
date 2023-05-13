import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:kutsu/providers/providers.dart';
import 'package:kutsu/singletons/application.dart';

class ProfileImage extends StatefulWidget {
  ProfileImage(
      {required this.userID,
      required this.editable,
      required this.size,
      super.key});

  final String userID;
  final bool editable;
  String imageURL = "";
  final String size;

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<ImagesProvider>().getProfileImage(widget.userID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          widget.imageURL = snapshot.data!;
          return SizedBox(
            height: (widget.size == "small") ? 110 : 180,
            width: (widget.size == "small") ? 90 : 140,
            child: GestureDetector(
              child: Column(
                children: [
                  if (widget.imageURL != "") ...[
                    SizedBox(
                      height: (widget.size == "small") ? 110 : 180,
                      width: (widget.size == "small") ? 90 : 140,
                      child: (FirebaseAuth.instance.currentUser!.uid ==
                              widget.userID)
                          ? Image.network(snapshot.data!)
                          : Image(
                              image:
                                  CachedNetworkImageProvider(snapshot.data!)),
                    )
                  ] else ...[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 242, 242, 242),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Color.fromARGB(255, 182, 182, 182),
                              width: 1),
                        ),
                        child: Center(
                            child: (widget.editable == true)
                                ? const Text('Valitse kuva')
                                : const Text('Ei kuvaa')),
                      ),
                    )
                  ]
                ],
              ),
              onTap: () async {
                if (widget.editable == true) {
                  final image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  if (image == null) return;
                  Application().addLoadingMessage("Päivitetään profiili kuvaa");

                  final newURL = await context
                      .read<ImagesProvider>()
                      .setProfileImage(File(image.path));

                  setState(() {
                    widget.imageURL = newURL;
                  });
                  Application().stopLoading();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                          body: Column(
                        children: [
                          Expanded(
                            child: Container(
                                color: const Color.fromARGB(255, 17, 17, 17)),
                          ),
                          GestureDetector(
                            child: Image(
                              image: CachedNetworkImageProvider(snapshot.data!),
                            ),
                            onTap: () {
                              context.pop();
                            },
                          ),
                          Expanded(
                            child: Container(
                                color: const Color.fromARGB(255, 17, 17, 17)),
                          ),
                        ],
                      )),
                    ),
                  );
                }
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            height: (widget.size == "small") ? 110 : 180,
            width: (widget.size == "small") ? 90 : 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  width: 1, color: Color.fromARGB(255, 133, 133, 133)),
              color: Color.fromARGB(255, 229, 229, 229),
            ),
            child: Center(child: Text('Ei kuvaa')),
          );
        }
        return Container(
          height: (widget.size == "small") ? 110 : 180,
          width: (widget.size == "small") ? 90 : 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(width: 1, color: Color.fromARGB(255, 107, 107, 107)),
            color: Color.fromARGB(255, 221, 221, 221),
          ),
          child: Center(child: Text('Ladataan')),
        );
      },
    );
  }
}
