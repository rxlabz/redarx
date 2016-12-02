import 'dart:async';

import 'package:redarx/src/action.dart';

/**
 * actions dispatcher
 */
class Dispatcher {
  StreamController<Action> streamr = new StreamController();

  /**
   * dispatched actions stream
   */
  get onDispatch => streamr.stream;

  dispatch(Action a) {
    streamr.add(a);
  }
}