import 'package:redarx/redarx.dart';
import 'package:redarx/src/commands.dart';


/// Commander configuration :
/// map [Request] to [CommandBuilder]
class CommanderConfig<A> {

  CommandBuilder operator [](key) {
    try {
      return map[key];
    } catch (err) {
      throw 'CommanderConfig[key] » No command defined for this Request ${key} \n $err';
    }
  }

  /// map of [RequestType] : [Command]<[AbstractModel]>
  Map<A, CommandBuilder<AbstractModel>> map;

  /// RequestTypes / CommandBuilders mapping injection
  CommanderConfig(this.map);

  /// return a Command constructor proxy from a (generic) ActionType
  @deprecated
  CommandBuilder<AbstractModel> getCommand(A type) =>
      map.keys.contains(type) ? map[type] : null;

  /// add post constructor
  void addHandler(Request a, CommandBuilder<AbstractModel> constructor) {
    map[a.type] = constructor;
  }
}
