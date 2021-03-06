import 'package:domain/repository/repository_base.dart';
import 'package:domain/entities/product.dart';
import 'package:domain/services/domain_event_service.dart';

abstract class ProductRepository extends RepositoryBase<Product> {
  ProductRepository(DomainEventService eventService) : super(eventService);

  Stream<List<Product>> getAllProductsByStoreId(String storeId);

  Stream<List<Product>> search(double latitude, double longitude, String query);
}
