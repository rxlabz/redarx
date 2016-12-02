import 'dart:async';
import 'package:redarx/src/commands.dart';
import 'package:redarx/src/model.dart';

/**
 * state manager
 */
class Store<T extends AbstractModel> {


  StreamController<T> dataEmitter = new StreamController<T>();
  Stream<T> get data$ => dataEmitter.stream;

  T get data => apply();

  List<Command<T>> history = [];

  StreamController<Command<T>> _historyController =
  new StreamController<Command<T>>.broadcast();
  Stream<Command<T>> history$;

  T state;

  InitialStateProvider initialStateProvider;

  Store(InitialStateProvider<T> this.initialStateProvider) {
    state = initialStateProvider().initial() as T;
    history$ = _historyController.stream;
    initStateHandler();
  }

  initStateHandler() {
    history$.listen((c) {
      history.add(c);
      apply();
    });
  }

  update(Command<T> c) {
    _historyController.add(c);
  }

  T apply() {
    var newState = history.fold(initialStateProvider().initial() as T,
            (T newState, Command<T> c) => c.exec(newState));
    dataEmitter.add(newState);
    return newState;
  }

  cancel() {
    if (history.isEmpty) return;
    history.removeLast();
    apply();
  }
}
