import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<T, A, NE> extends Cubit<T> {
  BaseCubit(super.initialState);

  Future<void> doAction(A action);

  final StreamController<NE> _navigationStream = StreamController.broadcast();
  Stream<NE> get navigation => _navigationStream.stream;

  void emitNavigation(NE effect) => _navigationStream.add(effect);

  @override
  Future<void> close() {
    _navigationStream.close();
    return super.close();
  }
}
