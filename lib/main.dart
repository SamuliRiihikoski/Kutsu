import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kutsu/src/features/lists/bloc/lists_bloc.dart';
import 'package:kutsu/src/features/loading/bloc/loading_bloc.dart';
import 'package:kutsu/src/features/datecard/datecard.dart';
import 'package:kutsu/providers/providers.dart';
import 'package:provider/provider.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatesProvider datesProvider = DatesProvider();
  AppProvider appProvider = AppProvider();
  ImagesProvider imagesProvider = ImagesProvider();
  RoomsProvider roomsProvider = RoomsProvider();

  await appProvider.init();
  datesProvider.initCache();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => appProvider),
        ChangeNotifierProvider(create: (context) => datesProvider),
        ChangeNotifierProvider(create: (context) => ImagesProvider()),
        ChangeNotifierProvider(create: (context) => roomsProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ListBloc>(create: (BuildContext context) => ListBloc()),
        BlocProvider<DateCardBloc>(
            create: (BuildContext context) => DateCardBloc()),
        BlocProvider<LoadingBloc>(
            create: (BuildContext context) =>
                LoadingBloc()..add(StartStreaming())),
      ],
      child: MaterialApp.router(
        title: 'Date Planner',
        routerConfig: appRouter,
      ),
    );
  }
}
