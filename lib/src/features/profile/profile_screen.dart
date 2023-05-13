import 'package:flutter/material.dart';
import 'package:kutsu/providers/providers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kutsu/singletons/application.dart';
import 'package:kutsu/src/features/lists/bloc/lists_bloc.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:kutsu/src/features/loading/bloc/loading_bloc.dart';
import 'package:kutsu/src/shared/shared.dart';
import 'package:kutsu/src/classes/classes.dart' as app;
import 'package:kutsu/singletons/activeuser.dart';
import 'package:kutsu/src/features/profile/profile_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int index = 0;
  @override
  String genderToFinnish(String value) {
    if (value == 'male')
      return 'mies';
    else if (value == 'female') return "nainen";
    return "muu";
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ActiveUser().getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          app.User user = snapshot.data!;
          return CustomScrollView(slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate([
              Stack(
                children: [
                  Container(
                    constraints: BoxConstraints(minHeight: 140, minWidth: 400),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(children: [
                      Stack(children: [
                        Container(
                          height: 180,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 242, 242, 242),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Color.fromARGB(255, 123, 123, 123),
                                width: 1),
                          ),
                          child: Center(child: Text('Lataa')),
                        ),
                        ProfileImage(
                          editable: true,
                          userID: user.userID,
                          size: "large",
                        ),
                      ]),
                      LabelRow(
                          title: 'Nimesi?:',
                          value: user.name,
                          onValueChanged: (value) {
                            user.name = value;
                            ActiveUser().updateWidgetUser(user);
                          }),
                    ]),
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(children: [
                    GroupDecoration(
                      label: "Henkilötiedot:",
                      child: [
                        SliderRow(
                            label: 'Ikä',
                            title: "Aseta oma ikä",
                            min: 18,
                            max: 70,
                            value: user.age,
                            onValueChanged: (value) {
                              user.age = value;
                              ActiveUser().updateWidgetUser(user);
                            }),
                        EnumRow(
                          label: 'Sukupuoli',
                          title: "Aseta oma sukupuoli",
                          value: genderToFinnish(user.gender),
                          options: ['mies', 'nainen', 'muu'],
                          onValueChanged: (value) {
                            if (value == 'mies')
                              user.gender = 'male';
                            else if (value == 'nainen')
                              user.gender = 'female';
                            else if (value == 'muu') user.gender = 'other';
                            ActiveUser().updateWidgetUser(user);
                            //App().user.gender = value;
                          },
                        ),
                        TextRow(
                          title: 'Kerro lyhyesti itsestäsi',
                          value: user.text,
                          onValueChanged: (value) {
                            user.text = value;
                            ActiveUser().updateWidgetUser(user);
                          },
                        ),
                      ],
                    ),
                    GroupDecoration(
                      label: "Haku asetukset:",
                      child: [
                        SliderRow(
                          label: 'Ikäero (+/-)',
                          title: "Ikäero",
                          min: 0,
                          max: 30,
                          value: user.filters!.age,
                          onValueChanged: (value) {
                            user.filters!.age = value;
                            ActiveUser().updateWidgetUser(user);
                          },
                        ),
                        EnumRow(
                          label: 'Sukupuoli',
                          title: "Aseta haettavan henkilön sukupuoli",
                          value: genderToFinnish(user.filters.gender),
                          options: ['mies', 'nainen', 'muu'],
                          onValueChanged: (value) {
                            if (value == 'mies')
                              user.filters.gender = 'male';
                            else if (value == 'nainen')
                              user.filters.gender = 'female';
                            else if (value == 'muu')
                              user.filters.gender = 'other';
                            ActiveUser().updateWidgetUser(user);
                          },
                        ),
                        SliderRow(
                          label: 'Maksimi etäisyys (km)',
                          title: "Maksimi etäisyys (km)",
                          min: 0,
                          max: 300,
                          value: user.filters!.distance,
                          onValueChanged: (value) {
                            user.filters!.distance = value;
                            ActiveUser().updateWidgetUser(user);
                          },
                        ),
                      ],
                    ),
                    GroupDecoration(
                      label: "Tilin hallinta",
                      child: [
                        EnumRow(
                          label: "Poista profiilini",
                          title: "Haluatko varmasti poistaa profiilisi?",
                          value: "",
                          isButton: true,
                          options: ["EI", "KYLLÄ"],
                          onValueChanged: (value) async {
                            if (value == "KYLLÄ") {
                              context.go('/delete');
                            }
                          },
                        ),
                      ],
                    ),
                  ]))
            ]))
          ]);
        }
        return const Center(
            child: Text(
          'Ladataan profiilia...',
          style: TextStyle(fontSize: 20),
        ));
      },
    );
  }
}
