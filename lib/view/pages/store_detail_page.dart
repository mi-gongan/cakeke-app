import 'package:cakeke/blocs/bloc_providers.dart';
import 'package:cakeke/blocs/store/store_bloc.dart';
import 'package:cakeke/config/design_system/design_system.dart';
import 'package:cakeke/data/models/common/store.dart';
import 'package:cakeke/view/widgets/common/custom_elevated_button.dart';
import 'package:cakeke/view/widgets/common/like_icon_button.dart';
import 'package:cakeke/view/widgets/common/scaffold_layout.dart';
import 'package:cakeke/view/widgets/common/score_widget.dart';
import 'package:cakeke/view/widgets/main/store/store_detail_empty_image.dart';
import 'package:cakeke/view/widgets/main/store/store_detail_image.dart';
import 'package:cakeke/view/widgets/main/store/store_info_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreDetailPage extends StatelessWidget {
  const StoreDetailPage({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      appBarText: "가게정보",
      isDetailPage: true,
      backgroundColor: DesignSystem.colors.white,
      onBackButtonPressed: () {
        Navigator.pop(context);
      },
      bodyWidget: MultiBlocProvider(
        providers: AppBlocProviders.mainPageBlocProviders,
        child: BlocBuilder<StoreBloc, StoreState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding:
                          const EdgeInsets.only(left: 16, bottom: 12, top: 6),
                      child: store.imgUrlList.isNotEmpty
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (final image in store.imgUrlList)
                                    StoreDetailImage(image: image)
                                ],
                              ),
                            )
                          : const StoreDetailEmptyImage()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                store.name,
                                style: DesignSystem.typography.display2(),
                              ),
                            ),
                            LikeIconButton(
                              store: store,
                              iconSize: 24,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        StoreInfoRow(
                          title: '별점',
                          child: Row(
                            children: [
                              Text(
                                '${store.starRating}',
                                style: DesignSystem.typography.body2(),
                              ),
                              const SizedBox(width: 4),
                              ScoreWidget(score: store.starRating),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/review',
                                    arguments: store.id,
                                  );
                                },
                                child: const Icon(
                                  (Icons.arrow_forward_ios),
                                  color: Colors.black,
                                  size: 14,
                                ),
                              )
                            ],
                          ),
                        ),
                        StoreInfoRow(
                          title: '영업시간',
                          child: Text(
                            "${store.startTime} ~ ${store.endTime}",
                            style: DesignSystem.typography.body2(),
                          ),
                        ),
                        StoreInfoRow(
                          title: '전화번호',
                          child: GestureDetector(
                              onTap: () => launchUrl(
                                  Uri(scheme: 'tel', path: store.phoneNumber)),
                              child: Text(
                                store.phoneNumber,
                                style: DesignSystem.typography.body(TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: DesignSystem.colors.lightBlue)),
                              )),
                        ),
                        StoreInfoRow(
                          title: '가게소개',
                          child: Text(
                            store.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: DesignSystem.typography.body2(),
                          ),
                        ),
                        StoreInfoRow(
                          title: '해시태그',
                          child: Text(
                            store.hashTag,
                            overflow: TextOverflow.fade,
                            style: DesignSystem.typography.body2(),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: CustomElevatedButton(
                            title: '예약',
                            onTap: () =>
                                launchUrl(Uri.parse(store.reservationLink)),
                            color: DesignSystem.colors.appPrimary,
                            textColor: DesignSystem.colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
