/**
 * Action : type , update value
 */
class Request<T, V> {
  T actionType;
  V value;

  Request(T this.actionType, {withValue}){
    value = withValue;
  }
}
