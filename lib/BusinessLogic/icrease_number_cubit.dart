import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'icrease_number_state.dart';

class IcreaseNumberCubit extends Cubit<IcreaseNumberState> {
  IcreaseNumberCubit() : super(IcreaseNumberInitial());

  int counter = 0;

  void icreaseNumber() {
    counter++;
    emit(icreaseNumberCounterState(x: counter));
  }

  void decrementNumber() {
    counter--;
    emit(decrementNumberState(d: counter));
  }

  void resetCounter() {
    counter = 0;
    emit(resetCounterState(v: counter));
  }
}
