import 'dart:async';

import 'package:redarx/src/commands.dart';
import 'package:redarx/src/model.dart';
import 'package:redarx/src/store.dart';

/// Store with a commands backup, allowing to cancel commands
class ReversibleStore<C extends Command<M>, M extends AbstractModel>
    extends Store<C, M> {

  /// model snapshot
  M get currentState => apply();

  /// commands history
  List<Command<M>> _history;

  List<Command<M>> get history => _history;

  /// Constructor
  ReversibleStore(InitialStateProvider<M> initialStateProvider)
      : super(initialStateProvider) {
    _history = [];
    initHistory(historyController.stream);
  }

  /// stock les commands ( sauf CancelCommand )
  void initHistory(Stream<Command<M>> hStream) {
    hStream.where((c) => !(c is CancelCommand)).listen((c) => history.add(c));
  }

  /// apply command history reducer
  M apply() =>
      history.fold(initialStateProvider().initial() as M,
              (M newState, Command<M> c) => c.exec(newState));

  /// cancel last command if exists and if
  void cancel() {
    if (history.isEmpty) return;

    history.removeLast();
    var prevState = apply();
    var cmd = new CancelCommand(prevState);
    update(cmd);
  }
}

/// re-inject evaluate prev state
class CancelCommand<T extends AbstractModel> extends Command<T> {
  T prevValue;

  CancelCommand(this.prevValue);

  // command execution just return previous value
  @override
  T exec(T model) => prevValue;
}
