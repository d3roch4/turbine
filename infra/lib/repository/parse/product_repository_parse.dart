import 'dart:async';

import 'package:application/repository/product_repository.dart';
import 'package:domain/entities/product.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class ProductRepositoryParse extends ProductRepository {
  ParseObject get parseObject => ParseObject('Product');

  @override
  Future<String> add(Product product) async {
    var obj = parseObject;
    setObjProduct(obj, product);

    await obj.save();
    return product.id = obj.objectId!;
  }

  Product objToProduct(ParseObject obj) {
    var product = Product(
        name: obj['name'],
        storeId: obj['storeId'],
        description: obj['description']);
    product.media = obj['media'];
    product.physical = obj['physical'];
    product.price = obj['price'];
    product.stockCount = obj['stockCount'];

    return product;
  }

  @override
  Future<Product?> getById(String id) async {
    var obj = await parseObject.getObject(id);
    if (obj.result != null) return objToProduct(obj.result);
    return null;
  }

  @override
  Future<void> update(Product entity) async {
    var obj = parseObject;
    obj.objectId = entity.id;
    setObjProduct(obj, entity);
    await obj.save();
  }

  void setObjProduct(ParseObject obj, Product product) {
    obj.set('name', product.name);
    obj.set('description', product.description);
    obj.set('media', product.media);
    obj.set('physical', product.physical);
    obj.set('price', product.price);
    obj.set('stockCount', product.stockCount);
    obj.set('storeId', product.storeId);
  }

  @override
  Stream<List<Product>> getAllByStoreId(String storeId) {
    // TODO: implement getAllByStoreId
    throw UnimplementedError();
  }
}