# Redarx (POC)

Experimental Dart State Management 
humbly inspired by [Parsley](http://www.spicefactory.org/parsley/) / [Redux](http://redux.js.org) / [ngrx](https://github.com/ngrx) and [André Stalz work](https://github.com/staltz)

![redarx-principles](docs/graphs/redarx_01_2.jpg)

## Goals

- study Dart : streams, generics, annotations, asynchrony...
- study Redux, Mobx,  state management
- experiment an Request/Commands pairing
- and more studies, more experiments...

## Principles

The Application State is managed by a (Generic)Store.

State is updated by commands, and the store keep a list of executed commands.

State is evaluated by a reducers of model commands updates, basic cancellation is allowed by simply remove the last command from "history".

A Commander listen to a stream of Requests dispatched by a Dispatcher injected in the applicaiton components | controllers | PM | VM

Each Request is defined by an RequestType, and can contains data. Requests are linked / tied to commandes 

- the dispatcher is injected in view || controller || PresentationModel || ViewModel  
- Controllers use the dispatcher to dispatch Requests
- Request are categorized by types, types are defined in RequestTypes
- the dispatcher stream dispatched Requests
- the dispatcher is injected in Commander
- the commander listen the Requests stream
- each Request is tied to a command via a CommanderConfig which is injected in Commander
- Commander need a CommanderConfig containing a Map<RequestType,Command>
- when an Request is dispatched, the commander add the corresponding command to the store
- the store then execute 
- a (synchronous) command is executed to update the store
- the store is injected in the commander

## TODO 

- implements a Scan stream transformer » just emit the last reduced state
- fix the generic/command ( <T extends Model> mess)
- typed Request ? BookRequest, UserRequest ...?
- async commands 
- more stream
- external config file ? dynamic runtime RequestType/Command Pair via defered libraries loading ?
- ...

## Questionning

- dispatcher : use a streamController.add rather than dispatch method ?
- multiple store ? dispatcher ? commander ?
- each component could set an Request stream and the commander could maybe listen to it
