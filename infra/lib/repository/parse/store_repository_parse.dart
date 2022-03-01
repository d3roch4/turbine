import 'package:application/repository/store_repository.dart';
import 'package:domain/entities/user.dart';
import 'package:domain/entities/store.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'helpers.dart';

class StoreRepositoryParse extends StoreRepository {
  ParseObject get parseObject => ParseObject('Store');

  @override
  Future<String> add(Store entity) async {
    var obj = storeToObj(entity);
    await obj.save();
    return obj.objectId!;
  }

  @override
  Future<Store?> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<Store>> getStoresByUser(User current) async {
    var queryBuilder = QueryBuilder(parseObject);
    queryBuilder.whereContains('employees.userId', current.id!);
    var results = await queryBuilder.find();
    return results.map((e) => objToStore(e)).toList();
  }

  @override
  Stream<List<Store>> getStoresByUserStream(User user) {
    var list = <Store>[].obs;
    QueryBuilder query = QueryBuilder(parseObject)
      ..whereEqualTo('employees.userId', user.id);
    ParseLiveList.create(query, lazyLoading: false).then((value) {
      var newList = <Store>[];
      for (var i = 0; i < value.size; i++) {
        newList.add(objToStore(value.getLoadedAt(i)!));
      }
      list.value = newList;
    });
    return list.stream;
  }

  @override
  Future<void> update(Store entity) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Store objToStore(ParseObject obj) {
    var store = Store(
        name: obj.get('name'),
        marketplaceId: obj.get('marketplaceId') ?? '',
        emailToNotifications: obj.get('emailToNotifications'),
        id: obj.objectId);
    return store;
  }

  ParseObject storeToObj(Store store) {
    var obj = parseObject;
    obj.objectId = store.id;
    obj.set('name', store.name);
    obj.set('emailToNotifications', store.emailToNotifications);
    obj.set('employees', store.employees.map((e) => e.toJson()).toList());
    return obj;
  }
}
