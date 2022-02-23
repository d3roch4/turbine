import 'package:application/repository/product_repository.dart';
import 'package:application/repository/store_repository.dart';
import 'package:domain/entities/product.dart';
import 'package:domain/entities/store.dart';
import 'package:flutter/material.dart';
import 'package:turbine/pages/error_page.dart';
import 'package:turbine/pages/loadding_page.dart';
import 'package:get/get.dart';
import 'package:turbine/widgets/image_product_widget.dart';
import 'package:turbine/widgets/loadding_widget.dart';

class ManagerStorePage extends StatelessWidget {
  var storeRepository = Get.find<StoreRepository>();
  var procutsRepository = Get.find<ProductRepository>();

  @override
  Widget build(BuildContext context) {
    return LoaddingPage.future<Store?>(
        future: storeRepository.getById(Get.parameters['id'] ?? ''),
        builder: (store) {
          if (store == null)
            return ErrorPage(message: 'id of store not found'.tr);
          return Scaffold(
            appBar: AppBar(title: Text(store.name)),
            body: LoaddingWidget.stream<List<Product>>(
                stream: procutsRepository.getAllByStoreId(store.id!),
                builder: (products) {
                  if (products == null || products.isEmpty) return empty();
                  return ListView.separated(
                    itemBuilder: (c, i) {
                      var item = products[i];
                      return ListTile(
                        leading: ImageProductWidget(item),
                        title: Text(item.name),
                        subtitle: Text(item.description),
                      );
                    },
                    itemCount: products.length,
                    separatorBuilder: (c, i) => Divider(),
                  );
                }),
          );
        });
  }

  Widget empty() => Center(child: Text('Add yours products'.tr));
}