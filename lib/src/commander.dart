library redarx;

import 'dart:async';

import 'package:redarx/src/commander-config.dart';
import 'package:redarx/src/commands.dart';
import 'package:redarx/src/model.dart';
import 'package:redarx/src/request.dart';
import 'package:redarx/src/reversible-store.dart';
import 'package:redarx/src/store.dart';

/// listen to dispatcher's stream of actions and
/// map them to commands, executed by the store on the model
class Commander<S extends Command<T>, T extends AbstractModel> {
  /// commander config : RequestType » Commands mapping
  CommanderConfig _config;

  /// store
  Store<S, T> store;

  /// [CommanderConfig] config / [Store]<AbstractModel> this.store
  /// [Stream]<Request> requestStream
  Commander(this._config, this.store, Stream<Request> requestStream) {
    requestStream.listen((Request req) => _exec(req));
  }

  /// cancel last store command
  cancel() {
    if (store is ReversibleStore) (store as ReversibleStore).cancel();
  }

  /// update store with Command defined by Request
  _exec(Request req) {
    print('Commander._exec req ${req}');
    store.update(_config[req.type](req.payload));
  }
}
