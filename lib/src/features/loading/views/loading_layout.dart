import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kutsu/src/features/loading/bloc/loading_bloc.dart';
import 'loading_screen.dart';

class LoadingLayout extends StatefulWidget {
  const LoadingLayout({required this.child, super.key});

  final Widget child;

  @override
  State<LoadingLayout> createState() => _LoadingLayoutState();
}

class _LoadingLayoutState extends State<LoadingLayout> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingBloc, LoadingState>(
      builder: (context, state) => Stack(
        children: [
          widget.child,
          if (state.isLoading == true) ...[
            const Opacity(opacity: 0.99, child: LoadingScreen())
          ]
        ],
      ),
    );
  }
}
