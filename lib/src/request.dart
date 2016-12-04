/**
 * Action : type , update value
 */
class Request<T, V> {
  T actionType;
  V value;

  Request(T this.actionType, {withValue}){
    value = withValue;
  }

  @override
  String toString() {
    return "Request{ type : $actionType , value $value }";
  }

}
