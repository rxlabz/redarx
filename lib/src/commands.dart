import 'package:redarx/src/action.dart';
import 'package:redarx/src/dispatcher.dart';
import 'package:redarx/src/model.dart';
import 'package:redarx/src/store.dart';

/**
 * type of method which provide a method to instantiate a new Command
 */
typedef Command<T> CommandBuilder<T>(dynamic value);


/**
 * Command Base class
 */
abstract class Command<G> {
  G exec(G model);
}

/**
 * listen to dispatcher's stream of actions and map them to commands, executed on the store
 */
class Commander {
  CommanderConfig config;

  Store<AbstractModel> store;

  Dispatcher dispatcher;

  Commander(CommanderConfig this.config, Store<AbstractModel> this.store,
      Dispatcher this.dispatcher) {
    dispatcher.onDispatch.listen((Action a) => xqt(a));
  }

  cancel() => store.cancel();

  exec(Command<AbstractModel> c) {
    store.update(c);
  }

  xqt(Action a) {
    exec(this.config.getHandler(a.type)(a.value));
  }
}

/**
 * pair Action » CommandBuilders
 */
class CommanderConfig<A> {
  Map<A, CommandBuilder<AbstractModel>> handlers;

  /**
   * A(ctionTypes) / CommandBuilders mapping injection
   */
  CommanderConfig(Map<A, CommandBuilder> map) {
    handlers = map;
  }

  /**
   * return a Command constructor proxy from a (generic) ActionType
   */
  CommandBuilder<AbstractModel> getHandler(A type) {
    return handlers.keys.contains(type) ? handlers[type] : null;
  }

  void addHandler(Action a, CommandBuilder<AbstractModel> constructor) {
    handlers[a.type] = constructor;
  }
}
