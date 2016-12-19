import 'dart:async';

import 'package:redarx/src/request.dart';

/// actions dispatcher
class Dispatcher {

  /// stream of command requests : requests are added via the dispatch() method
  final StreamController<Request> requestController = new StreamController<Request>.broadcast();
  /// dispatched [Stream]<[Request]>
  Stream<Request> get request$ => requestController.stream;

  /// stream of queries : queries are alternative messaging bus
  /// it canbe used for non store commands like firebase requests
  final StreamController<Request> queryController = new StreamController<Request>.broadcast();
  Stream<Request> get querie$ => queryController.stream;

  /// add [Request] to stream
  void dispatch(Request req) => requestController.add(req);

  /// add [Request] to stream
  void query(Request req) => queryController.add(req);
}