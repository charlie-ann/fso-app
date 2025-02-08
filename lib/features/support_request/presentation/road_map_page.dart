import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:fso_support/core/utils/extensions.dart';
import 'package:fso_support/features/support_request/presentation/support_details_page.dart';
import 'package:fso_support/features/support_request/providers/support_req_prov.dart';
import 'package:fso_support/features/support_request/state/support_req_state.dart';
import 'package:go_router/go_router.dart';

class RoadMapPage extends ConsumerStatefulWidget {
  static const String routeName = 'road-map-page';
  const RoadMapPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RoadMapPageState();
}

class _RoadMapPageState extends ConsumerState<RoadMapPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchRoadMap(ref: ref);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final requestList = ref.watch(roadMapListProv);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Road Map",
          style: context.textTheme.titleMedium?.copyWith(fontSize: 16.text),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        itemBuilder: (context, index) {
          final request = requestList[index];
          return GestureDetector(
            onTap: () =>
                context.pushNamed(SupportDetailsPage.routeName, extra: request),
            child: Container(
              height: 84,
              decoration: BoxDecoration(
                color: AppColors.white,
                border:
                    Border.all(color: AppColors.borderGrey.withOpacity(0.12)),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 10,
                    height: 70,
                    width: MediaQuery.of(context).size.width - 60,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                request.terminal?.merchantName ?? "",
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontSize: 14,
                                  color: AppColors.blackText,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Text.rich(
                                TextSpan(
                                  text: "TID    : ",
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.blackText,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: request.terminal?.terminalId ?? "",
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: AppColors.bodyTextGrey,
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.black.withOpacity(.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemCount: requestList.length,
      ),
    );
  }
}
