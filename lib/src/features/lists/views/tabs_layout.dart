import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kutsu/router.dart' as router;
import 'package:go_router/go_router.dart';
import 'package:kutsu/singletons/application.dart';
import 'package:kutsu/src/features/profile/profile_screen.dart';
import 'package:kutsu/src/features/lists/lists.dart';
import 'package:kutsu/singletons/activeuser.dart';

class HomeLayout extends StatefulWidget {
  HomeLayout({super.key}) {}

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> with TickerProviderStateMixin {
  late TabController _controller;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ListBloc>().add(InitLists());
    _controller =
        TabController(length: router.destinations.length, vsync: this);

    _controller.addListener(() async {
      if (_controller.previousIndex == 3) {
        bool compareFilters = ActiveUser().compareFilteres();
        bool compareProfile = ActiveUser().compareProfiles();

        if (!compareProfile || !compareFilters) {
          (!compareFilters)
              ? Application().addLoadingMessage("Haetaan kutsuja...")
              : Application().addLoadingMessage("Tallennetaan profiilia");
          await ActiveUser().setProfile();
          Application().stopLoading();
        }

        if (!compareFilters) {
          Application().changeTabIndex = 0;
          context.read<ListBloc>().add(RefreshCalendar());
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ListBloc, ListState>(
      listener: (context, state) {
        _controller.index = Application().changeTabIndex;
      },
      builder: (context, state) {
        return DefaultTabController(
          initialIndex: state.currentTabIndex,
          length: router.destinations.length,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(35),
              child: AppBar(
                centerTitle: false,
                backgroundColor: Colors.white,
                elevation: 1.0,
                bottomOpacity: 1.0,
                toolbarHeight: 10,
                bottom: TabBar(
                    controller: _controller,
                    tabs: router.destinations
                        .map(
                          (e) => Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Center(
                              child: Text(
                                e.label,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 66, 66, 66),
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        )
                        .toList()),
              ),
            ),
            body: TabBarView(
              controller: _controller,
              children: [
                CalendarList(),
                Scaffold(
                  body: CreatedList(),
                  bottomNavigationBar: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        height: 1,
                        color: Colors.black,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Luo uusi kutsu',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: () {
                          //Singleton().test();
                          //context.read<ListBloc>().add(FetchCalendar());
                          context.go('/create');
                        },
                      ),
                    ]),
                  ),
                ),
                const LikedList(),
                const ProfileScreen()
              ],
            ),
          ),
        );
      },
    );
  }
}
