import 'package:cakeke/blocs/map/map_bloc.dart';
import 'package:cakeke/blocs/map/map_event.dart';
import 'package:cakeke/blocs/map/map_state.dart';
import 'package:cakeke/blocs/store/store_bloc.dart';
import 'package:cakeke/config/design_system/design_system.dart';
import 'package:cakeke/view/widgets/main/map/main_text_field_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapSearchField extends StatelessWidget {
  const MapSearchField({super.key, required this.searchFocus});

  final FocusNode searchFocus;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(buildWhen: (previous, current) {
      return previous.searchText != current.searchText;
    }, builder: (context, state) {
      return BlocListener<StoreBloc, StoreState>(
          listener: (context, storeState) {
            if (storeState.fetching) {
              context.read<MapBloc>().add(const UpdateMapStoreEvent());

              Future.delayed(const Duration(milliseconds: 100), () {
                context.read<StoreBloc>().add(const StoreFetchComplete());
              });
            }
          },
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: DesignSystem.colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 10,
                    )
                  ]),
              child: MainTextFieldRow(
                searchFocus: searchFocus,
                onSubmitted: (text) => startSearch(context, text),
                onChanged: (text) {
                  context
                      .read<MapBloc>()
                      .add(SearchTextChangedEvent(searchText: text));
                },
                onSearchTap: () => startSearch(context, state.searchText),
              ),
            ),
          ));
    });
  }

  void startSearch(BuildContext context, String text) {
    context.read<StoreBloc>().add(StoreEventFetchSearch(
        search: text,
        onSearchComplete: (latitude, longitude) {
          context
              .read<MapBloc>()
              .add(SetLocationEvent(latitude: latitude, longitude: longitude));
        }));
  }
}
