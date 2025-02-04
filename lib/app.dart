import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/core/config/router/router.dart';
import 'package:fso_support/core/config/themes/theme.dart';
import 'package:fso_support/core/size_config/config.dart';
import 'package:fso_support/core/utils/resusable_state/provider.dart';

class FsoSupportApp extends ConsumerStatefulWidget {
  const FsoSupportApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FsoSupportAppState();
}

class _FsoSupportAppState extends ConsumerState<FsoSupportApp> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Consumer(
      builder: (_, WidgetRef ref, __) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: MaterialApp.router(
            title: "FSO Support",
            theme: FAppTheme.lightTheme,
            darkTheme: FAppTheme.lightTheme,
            themeMode: ref.watch(themeModeProvider),
            debugShowCheckedModeBanner: false,
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
            routeInformationProvider: router.routeInformationProvider,
          ),
        );
      },
    );
  }
}
