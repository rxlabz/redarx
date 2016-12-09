// Copyright (c) 2016, Me. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:redarx/redarx.dart';
import 'package:test/test.dart';


void main() {
  group('A group of tests', () {
    Store store;

    setUp(() {
      store = new Store(()=>new Model()..initial());
    });

    test('initial store state is an empty model', () {
      /*expect( store.data is Model , isTrue);
      expect( (store.data as Model).text , isEmpty);
      expect( (store.data as Model).number , isZero);
      expect( (store.data as Model).list , isEmpty);
      expect( (store.data as Model).map , isEmpty);*/
    });
  });
}

class Model extends AbstractModel{

  String text;
  int number;
  List<String> list;
  Map<String, dynamic> map;

  @override
  AbstractModel initial() => new Model()..text=''..number=0..list=[]..map={};
}