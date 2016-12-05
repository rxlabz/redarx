import 'package:redarx/src/request.dart';
import 'package:redarx/src/dispatcher.dart';
import 'package:redarx/src/model.dart';
import 'package:redarx/src/store.dart';

/**
 * type of method which provide a method to instantiate a new Command
 */
typedef Command<T> CommandBuilder<T extends AbstractModel>(dynamic value);


/**
 * Command Base class
 */
abstract class Command<G extends AbstractModel> {
  G exec(G model);
}

/**
 * listen to dispatcher's stream of actions and map them to commands, executed on the store
 */
class Commander {
  /**
   * commander config : RequestType » Commands mapping
   */
  CommanderConfig config;

  /**
   * store
   */
  Store<AbstractModel> store;

  /**
   * request dispatcher
   */
  Dispatcher dispatcher;

  /**
   *
   * @param CommanderConfig config
   * @param Store<AbstractModel> this.store
   * @param Dispatcher this.dispatcher
   */
  Commander(CommanderConfig this.config, Store<AbstractModel> this.store,
      Dispatcher this.dispatcher) {
    dispatcher.onRequest.listen((Request a) => exec(a));
  }

  /**
   * cancel last store command
   */
  cancel() => store.cancel();

  /**
   * update store with Command defined by Request
   */
  exec(Request a) {
    var handler = this.config.getHandler(a.actionType);
    try{
      store.update(handler(a.value));
    } catch (err){
      print('Commander.handle... No command defined for this Action ${a} \n $err');
    }
  }
}

/**
 * pair Action » CommandBuilders
 */
class CommanderConfig<A> {
  Map<A, CommandBuilder<AbstractModel>> handlers;

  /**
   * RequestTypes / CommandBuilders mapping injection
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

  /**
   * add post constructor
   */
   // TODO : define use cases
  void addHandler(Request a, CommandBuilder<AbstractModel> constructor) {
    handlers[a.actionType] = constructor;
  }
}
