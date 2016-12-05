import 'dart:async';

import 'package:redarx/src/commands.dart';
import 'package:redarx/src/model.dart';

/// state manager
class Store<T extends AbstractModel> {
  /// model stream controller
  StreamController<T> _modelEmitter = new StreamController<T>();

  /// model$ stream
  Stream<T> get data$ => _modelEmitter.stream;

  /// model snapshot
  T get data => apply();

  /// commands history
  List<Command<T>> history = [];

  /// command stream controller
  StreamController<Command<T>> _historyController =
      new StreamController<Command<T>>.broadcast();

  /// Commands Stream
  Stream<Command<T>> history$;

  /// currentState
  T state;

  /// initial state provider function cf. [InitialStateProvider]
  InitialStateProvider<T> initialStateProvider;

  /// get initialState & init history$ stream
  Store(this.initialStateProvider) {
    state = initialStateProvider().initial() as T;
    history$ = _historyController.stream;
    _initStateHandler();
  }

  /// init history$ stream listening
  _initStateHandler() {
    history$.listen((c) {
      history.add(c);
      apply();
    });
  }

  /// model update request via a new command
  /// command is added to history$
  void update(Command<T> c) => _historyController.add(c);

  /// apply command history reducer
  T apply() {
    final newState = history.fold(initialStateProvider().initial() as T,
        (T newState, Command<T> c) => c.exec(newState));
    _modelEmitter.add(newState);
    return newState;
  }

  /// cancel last command if exists
  cancel() {
    if (history.isEmpty) return;
    history.removeLast();
    apply();
  }
}
