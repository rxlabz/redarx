import 'package:redarx/redarx.dart';
import 'package:redarx/src/commands.dart';


/// Commander configuration :
/// map [RequestType] to [CommandBuilder]
class CommanderConfig<A,M> {

  CommandBuilder<M> operator [](A key) {
    try {
      return map[key];
    } catch (err) {
      throw 'CommanderConfig[key] » No command defined for this Request ${key} \n $err';
    }
  }

  /// map of [RequestType] : [Command]<[AbstractModel]>
  Map<A, CommandBuilder<M>> map;

  /// RequestTypes / CommandBuilders mapping injection
  CommanderConfig(this.map);

  /// return a Command constructor proxy from a (generic) ActionType
  @deprecated
  CommandBuilder<M> getCommand(A type) =>
      map.keys.contains(type) ? map[type] : null;

  /// add post constructor
  void addHandler(Request<A, dynamic> a, CommandBuilder<M> constructor) {
    map[a.type] = constructor;
  }
}
