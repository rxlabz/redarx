/**
 * Action : type , update value
 */
class Action<T, V> {
  T type;
  V value;

  Action(T this.type, {withValue}){
    value = withValue;
  }
}
