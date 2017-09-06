import 'dart:async';

import 'package:redarx/src/request.dart';

typedef void DispatchFn(Request req);

/// Request dispatcher
/// provide dispatch and query methods to send requests
class Dispatcher {
  /// stream of command requests : requests are added via the dispatch() method
  final StreamController<Request> _requestController =
      new StreamController<Request>.broadcast();

  /// dispatched [Stream]<[Request]>
  Stream<Request> get request$ => _requestController.stream;

  /// stream of queries : queries are alternative messaging bus
  /// it canbe used for non store commands like firebase requests
  final StreamController<Request> queryController =
      new StreamController<Request>.broadcast();
  Stream<Request> get querie$ => queryController.stream;

  /// add [Request] to stream
  void dispatch(Request req) => _requestController.add(req);

  /// add [Request] to query stream cf.firebase
  void query(Request req) => queryController.add(req);
}
