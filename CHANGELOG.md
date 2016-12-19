# Changelog

## 0.6.0

- prototypal "multi-channels" dispatcher (temporary): 
  - query() => QUERIE$ => Prototypal FirebaseService integration
  - dispatch() => REQUEST$ => Commander 
  
- strong mode with no implicit casts or dynamic

## 0.5.0

- immutable model
- refactoring
- Angular Dart compatible

## 0.4.0

- Async Commands

## 0.2.1

- CommandConfig : overload operator[] » allow accessing RequestType associated Command via `config[RequestType]`
- [generated doc](https://rxlabz.github.io/redarx)

## 0.2.0

- remove Dispatcher injection from AppRoot & Commander
- dart doc generation

## 0.0.1

- Initial version : 
  - synchronous commands mapped to Action defined by ActionTypeEnum,
  - ActionType enum definition,
  - basic Action Dispatcher, 
  - Commander : listen to dispatched action and
  - Store with Commands reducer
  - basic mapping config
  - basic undo
