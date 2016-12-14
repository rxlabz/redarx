import 'dart:async';

import 'package:meta/meta.dart';
import 'package:redarx/src/commands-reducer-transformer.dart';
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

  /// command stream controller
  @protected
  StreamController<AsyncCommand<M>> asyncHistoryController =
  new StreamController<AsyncCommand<M>>.broadcast();

  /// model update request via a new command
  /// command is added to history$
  void update(Command<AbstractModel> c) => historyController.add(c);

  void updateAsync(AsyncCommand<AbstractModel> c) =>
      asyncHistoryController.add(c);

  /// get initialState & init history$ stream
  Store(this.initialStateProvider) {
    var historyStream = historyController.stream;

    state$ = historyStream.transform(
        new CommandStreamReducer<Command<M>, M>.broadcast(
            initialStateProvider().initial() as M));
  }
}
