import 'dart:async';

import 'package:redarx/src/request.dart';

/// actions dispatcher
class Dispatcher {
  StreamController<Request> streamr = new StreamController();

  /// dispatched [Stream]<[Request]>
  Stream<Request> get onRequest => streamr.stream;

  /// add [Request]
  dispatch(Request a) => streamr.add(a);
}