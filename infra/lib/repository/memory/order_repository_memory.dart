import 'dart:async';

import 'package:application/repository/order_repository.dart';
import 'package:application/repository/product_repository.dart';
import 'package:domain/entities/order.dart';
import 'package:get/get.dart';
import 'package:infra/repository/memory/repository_base_memory.dart';

class OrderRepositoryMemory extends OrderRepository {
  var wrapperd = RepositoryBaseMemory<Order>();

  @override
  Future<String> addOrder(Order entity) async {
    var repoProducts = Get.find<ProductRepository>();
    for (var pc in entity.products) {
      var produto = await repoProducts.getById(pc.productId);
      produto!.stockCount -= pc.count;
      if (produto.stockCount < 0)
        throw AssertionError('stockCount is less than coun');
    }
    return wrapperd.add(entity);
  }

  @override
  Future<Order> getByCartId(String id) async {
    return wrapperd.memory.firstWhere((element) => element.cartId == id);
  }

  @override
  Future<Order?> getById(String id) {
    return wrapperd.getById(id);
  }

  @override
  Future<void> update(Order entity) {
    return wrapperd.update(entity);
  }
}