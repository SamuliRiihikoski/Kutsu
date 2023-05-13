part of 'loading_bloc.dart';

class LoadingState extends Equatable {
  LoadingState({required this.isLoading, required this.message});

  final bool isLoading;
  final String message;

  LoadingState copyWith({bool? isLoading, String? message}) {
    return LoadingState(
        isLoading: isLoading ?? this.isLoading,
        message: message ?? this.message);
  }

  @override
  List<Object> get props => [isLoading];
}
