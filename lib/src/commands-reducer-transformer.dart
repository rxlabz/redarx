import 'dart:async';

import 'package:redarx/redarx.dart';

/**
 * Stream transformer : reduce new state from commands stream
 * transform a Stream<Command> to Stream<AbstractModel>
 */
class CommandStreamReducer<S extends Command<T>, T extends AbstractModel>
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

  // on stream data : exec (sync or async) the command
  // & inject newstate in the state$ stream
  Future onData(S cmd) async {
    if (cmd is AsyncCommand)
      state = await (cmd as AsyncCommand<T>).execAsync(state);
    else
      state = cmd.exec(state);
    _controller.add(state);
  }

  @override
  Stream<T> bind(Stream<S> stream) {
    this._stream = stream;
    return _controller.stream;
  }
}
