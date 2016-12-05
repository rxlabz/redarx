# Changelog

## 0.2.1

- CommandConfig : overload operator[] » allow accessing RequestType associated Command via `config[RequestType]`

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
