import 'dart:async';

import 'package:redarx/src/request.dart';

/// actions dispatcher
class Dispatcher {

  /// stream of command requests : requests are added via the dispatch() method
  final StreamController<Request> streamController = new StreamController();

  /// dispatched [Stream]<[Request]>
  Stream<Request> get request$ => streamController.stream;

  /// add [Request] to stream
  void dispatch(Request a) => streamController.add(a);
}