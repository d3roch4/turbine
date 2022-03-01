import 'package:application/repository/repository_base.dart';
import 'package:domain/entities/store.dart';
import 'package:domain/entities/user.dart';

abstract class StoreRepository extends RepositoryBase<Store> {
  Future<List<Store>> getStoresByUser(User current);
  Stream<List<Store>> getStoresByUserStream(User current);
}
