import 'dart:async';

import 'package:redarx/src/model.dart';

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



