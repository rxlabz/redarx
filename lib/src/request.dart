/// Request<RequestType,dynamic|VO>
typedef void Dispatch<T,V>(Request<T, V> req);

/// Request aka Action, aka Events, aka Notification : type , update value
class Request<T, V> {
  /// type of request
  final T type;

  /// value (optionnal)
  final V payload;

  /// build a Request with an enum type and optional value
  const Request(T this.type, {V withData}):payload = withData;

  @override
  String toString() {
    return "Request{ type : $type , value $payload }";
  }
}