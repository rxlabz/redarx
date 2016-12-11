import 'dart:async';

import 'package:redarx/src/model.dart';
import 'package:redarx/src/request.dart';
import 'package:redarx/src/reversible-store.dart';
import 'package:redarx/src/store.dart';

/// type of method which provide a method to instantiate a new Command
typedef Command<T> CommandBuilder<T extends AbstractModel>(value);

/// type of method which provide a method to instantiate a new AsyncCommand
typedef AsyncCommand<T> AsyncCommandBuilder<T extends AbstractModel>(value);

/// Command Base class
abstract class Command<G extends AbstractModel> {
  G exec(G state);
}

/// Command Base class
abstract class AsyncCommand<G extends AbstractModel> extends Command<G> {
  Future<G> execAsync(G state);

  ///
  @override
  G exec(G state) {
    throw "Error ! async commands should not use exec() but execAsync() instead";
  }
}

/// listen to dispatcher's stream of actions and
/// map them to commands, executed by the store on the model
class Commander<S extends Command<T>, T extends AbstractModel> {

  /// commander config : RequestType » Commands mapping
  CommanderConfig config;

  /// store
  Store<S, T> store;

   /// [CommanderConfig] config / [Store]<AbstractModel> this.store
   /// [Stream]<Request> requestStream
  Commander(this.config, this.store, Stream<Request> requestStream) {
    requestStream.listen((Request req) => exec(req));
  }

  /// cancel last store command
  cancel() {
    if (store is ReversibleStore)
      (store as ReversibleStore).cancel();
  }

  /// update store with Command defined by Request
  exec(Request req) {
    store.update(config[req.type](req.payload));
  }
}

/// Commander configuration :
/// map [Request] to [CommandBuilder]
class CommanderConfig<A> {

  CommandBuilder operator [](key) {
    try {
      return map[key];
    } catch (err) {
      throw 'CommanderConfig[key] » No command defined for this Request ${key} \n $err';
    }
  }

  /// map of [RequestType] : [Command]<[AbstractModel]>
  Map<A, CommandBuilder<AbstractModel>> map;

  /// RequestTypes / CommandBuilders mapping injection
  CommanderConfig(this.map);

  /// return a Command constructor proxy from a (generic) ActionType
  @deprecated
  CommandBuilder<AbstractModel> getCommand(A type) =>
      map.keys.contains(type) ? map[type] : null;

  /// add post constructor
  void addHandler(Request a, CommandBuilder<AbstractModel> constructor) {
    map[a.type] = constructor;
  }
}
