import 'package:application/services/marketplace_manager_service.dart';
import 'package:domain/repository/marketplace_repository.dart';
import 'package:domain/entities/marketplace.dart';
import 'package:get/get.dart';

class MarketplaceManagerServiceParse extends MarketplaceManagerService {
  MarketplaceRepository repository;
  Marketplace? current;

  MarketplaceManagerServiceParse(this.repository) {
    currentMarketplace();
  }

  @override
  Future<Marketplace?> currentMarketplace() async {
    var id = Get.parameters["mp"];
    if (id != null) {
      if (id == current?.id)
        return current!;
      else {
        current = await repository.getById(id);
        return current;
      }
    }
    return repository.getFirst();
  }
}
