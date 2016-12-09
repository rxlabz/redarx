import 'dart:async';

import 'package:meta/meta.dart';
import 'package:redarx/src/commands.dart';
import 'package:redarx/src/model.dart';

/// state manager
class Store<C extends Command<M>, M extends AbstractModel> {

  Stream<M> state$;

  /// initial state provider function cf. [InitialStateProvider]
  InitialStateProvider<M> initialStateProvider;

  /// command stream controller
  @protected
  StreamController<Command<M>> historyController =
  new StreamController<Command<M>>.broadcast();

  /// model update request via a new command
  /// command is added to history$
  void update(Command<AbstractModel> c) => historyController.add(c);

  /// get initialState & init history$ stream
  Store(this.initialStateProvider) {
    var historyStream = historyController.stream;

    state$ = historyStream.transform(
        new CommandStreamReducer<Command<M>, M>.broadcast(
            initialStateProvider().initial() as M));
  }

}

/**
 * Stream transformer : reduce state from commands stream
 * transform a Stream<Command> en Stream<AbstractModel>
 */
class CommandStreamReducer<S extends Command, T extends AbstractModel>
    implements StreamTransformer<S, T> {
  T state;

  List<S> history;

  StreamController<T> _controller;

  bool cancelOnError;

  StreamSubscription _subscription;

  Stream<S> _stream;

  CommandStreamReducer(this.state, {bool sync: false, this.cancelOnError}) {
    _controller = new StreamController<T>(
        onListen: _onListen,
        onCancel: _onCancel,
        onPause: () {
          _subscription.pause();
        },
        onResume: () {
          _subscription.resume();
        },
        sync: sync);
  }

  CommandStreamReducer.broadcast(this.state,
      {bool sync: false, this.cancelOnError}) {
    _controller = new StreamController<T>.broadcast(
        onListen: _onListen, onCancel: _onCancel, sync: sync);
  }

  void _onListen() {
    _subscription = _stream.listen(onData,
        onError: _controller.addError,
        onDone: _controller.close,
        cancelOnError: cancelOnError);
  }

  void _onCancel() {
    _subscription.cancel();
    _subscription = null;
  }

  Future onData(S cmd) async {
    state = cmd.exec(state);
    _controller.add(state);
  }

  @override
  Stream<T> bind(Stream<S> stream) {
    this._stream = stream;
    return _controller.stream;
  }
}
