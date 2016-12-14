typedef void Dispatch(Request);

/// Request aka Action, aka Events, aka Notification : type , update value
class Request<T, V> {
  /// type of request
  T type;

  /// value (optionnal)
  V payload;

  /// build a Request with an enum type and optional value
  Request(T this.type, {V withData}):payload = withData{
  }

  @override
  String toString() {
    return "Request{ type : $type , value $payload }";
  }

}
