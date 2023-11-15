import 'package:cakeke/data/providers/store_provider.dart';
import 'package:cakeke/data/repositories/store_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cakeke/data/models/common/store.dart';
import 'package:equatable/equatable.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(StoreState()) {
    on<StoreEventFetchLocal>(handleFetchLocal);
    on<StoreEventFetchSearch>(handleFetchSearch);
    on<StoreEventFetchLike>(handleFetchLike);
    on<StoreEventAddLike>(handleAddLike);
    on<StoreEventRemoveLike>(handleRemoveLike);
    on<StoreFetchComplete>(_handleStoreFetchComplete);
  }

  final StoreRepository storeRepository =
      StoreRepository(storeProvider: StoreProvider());

  Future<void> handleFetchLocal(
      StoreEventFetchLocal event, Emitter<StoreState> emit) async {
    final storeInfo = await storeRepository.fetchLocalStoreList(
      event.latitude,
      event.longitude,
    );
    emit(state.copyWith(storeList: storeInfo.storeList, fetching: true));
  }

  void handleFetchSearch(
      StoreEventFetchSearch event, Emitter<StoreState> emit) async {
    final storeList = await storeRepository.fetchSearchStoreList(event.search);
    event.onSearchComplete(storeList.centerLatitude, storeList.centerLongitude);
    emit(state.copyWith(storeList: storeList.storeList, fetching: true));
  }

  void handleFetchLike(
      StoreEventFetchLike event, Emitter<StoreState> emit) async {
    final List<Store> storeList = await storeRepository.fetchLikeStoreList();
    emit(state.copyWith(storeList: storeList, fetching: false));
  }

  void handleAddLike(StoreEventAddLike event, Emitter<StoreState> emit) async {
    final Store store = await storeRepository.addLike(event.storeId);
    emit(state.copyWith(
      storeList:
          state.storeList!.map((e) => e.id == store.id ? store : e).toList(),
    ));
  }

  void handleRemoveLike(
      StoreEventRemoveLike event, Emitter<StoreState> emit) async {
    final Store store = await storeRepository.removeLike(event.storeId);
    emit(state.copyWith(
      storeList:
          state.storeList!.map((e) => e.id == store.id ? store : e).toList(),
    ));
  }

  void _handleStoreFetchComplete(
      StoreFetchComplete event, Emitter<StoreState> emit) {
    emit(state.copyWith(fetching: false));
  }
}
