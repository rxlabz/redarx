import 'dart:async';

import 'package:redarx/src/request.dart';

/**
 * actions dispatcher
 */
class Dispatcher {
  StreamController<Request> streamr = new StreamController();

  /**
   * dispatched actions stream
   */
  get onDispatch => streamr.stream;

  dispatch(Request a) {
    streamr.add(a);
  }
}