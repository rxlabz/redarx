/// provide Model.empty() proxy
typedef S InitialStateProvider<S extends AbstractModel>();

/// state Model base class
abstract class AbstractModel {

  const AbstractModel();

  /// provide an instance of the model in initialState
  AbstractModel initial();
}
