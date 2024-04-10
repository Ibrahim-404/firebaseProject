part of 'icrease_number_cubit.dart';

@immutable
abstract class IcreaseNumberState {}

class IcreaseNumberInitial extends IcreaseNumberState {}

class icreaseNumberCounterState extends IcreaseNumberState {
  final int x;
  icreaseNumberCounterState({required this.x});
}

class decrementNumberState extends IcreaseNumberState {
  final int d;
  decrementNumberState({required this.d});
}

class resetCounterState extends IcreaseNumberState {
  final int v;
  resetCounterState({required this.v});
}
