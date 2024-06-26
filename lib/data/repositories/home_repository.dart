import 'package:cakeke/data/models/common/store.dart';
import 'package:cakeke/data/providers/home_provider.dart';

class HomeRepository {
  final HomeProvider homeProvider;

  HomeRepository({
    required this.homeProvider,
  });

  Future<List<Store>> getNewStoreList() async {
    return await homeProvider.getNewStoreList();
  }

  Future<List<Store>> getPopularStore() async {
    return await homeProvider.getPopularStore();
  }

  Future<List<Store>> getStoreRanking(
      {required String city, required String district}) async {
    return await homeProvider.getStoreRanking(city: city, district: district);
  }
}
