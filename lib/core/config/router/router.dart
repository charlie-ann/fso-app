import 'package:flutter/material.dart';
import 'package:fso_support/dashboard.dart';
import 'package:fso_support/features/auth/presentation/change_password.dart';
import 'package:fso_support/features/history/models/history_model.dart';
import 'package:fso_support/features/log_support/presentation/create_task.dart';
import 'package:fso_support/features/log_support/presentation/qr_scanner.dart';
import 'package:fso_support/features/support_request/models/support_request.dart';
import 'package:fso_support/features/support_request/presentation/photo_view.dart';
import 'package:fso_support/features/support_request/presentation/road_map_page.dart';
import 'package:fso_support/features/terminals/models/terminal_model.dart';
import 'package:fso_support/features/terminals/presentation/active_terminals.dart';
import 'package:fso_support/features/terminals/presentation/inactive_terminals.dart';
import 'package:fso_support/features/log_support/presentation/log_support.dart';
import 'package:fso_support/features/auth/presentation/login.dart';
import 'package:fso_support/features/support_request/presentation/support_details_page.dart';
import 'package:fso_support/features/history/presentation/history_detail.dart';
import 'package:fso_support/features/history/presentation/history_page.dart';
import 'package:fso_support/features/support_request/presentation/support_request_page.dart';
import 'package:fso_support/features/terminals/presentation/terminal_details.dart';
import 'package:go_router/go_router.dart';

/// Main router for CropXchange.
///
/// ! Pay attention to the order of routes.
/// Create:  example/create
/// View:    example/:eid
/// Edit:    example/:eid/edit
/// where :edit means example entity id.
///
/// ! Note about parameters
/// Router keeps parameters in global map. It means that if you create route
/// organization/:id and organization/:id/department/:id. Department id will
///  override organization id. So use :oid and :did instead of :id
/// Also router does not provide option to set regex for parameters.
/// If you put - example/:eid before - example/create for route - example/create
/// will be called route - example/:eid
///
///
final navigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/${LoginPage.routeName}',
      name: LoginPage.routeName,
      builder: (context, state) => const LoginPage(),
      redirect: (context, state) async {
        // final prov = ProviderScope.containerOf(context, listen: true);

        // Future.delayed(const Duration(seconds: 1), () {
        //   final isFirst = prov.read(isFirstVisit);
        //   log(isFirst.toString(), name: "heeee");
        //   if (isFirst) {
        //     navigatorKey.currentContext?.go("/${IntroPage.routeName}");
        //   } else {
        //     navigatorKey.currentContext?.go("/${PasscodeSigninPage.routeName}");
        //   }
        // });
        return null;
      },
    ),
    GoRoute(
      path: '/${DashboardPage.routeName}',
      name: DashboardPage.routeName,
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/${SupportRequestPage.routeName}',
      name: SupportRequestPage.routeName,
      builder: (context, state) => const SupportRequestPage(),
    ),
    GoRoute(
      path: '/${SupportDetailsPage.routeName}',
      name: SupportDetailsPage.routeName,
      builder: (context, state) => SupportDetailsPage(
        supportRequestModel: state.extra as SupportRequestModel,
      ),
    ),
    GoRoute(
      path: '/${LogSupportPage.routeName}',
      name: LogSupportPage.routeName,
      builder: (context, state) => LogSupportPage(
        terminal: state.extra as TerminalParams?,
      ),
    ),
    GoRoute(
      path: '/${SupportHistoryPage.routeName}',
      name: SupportHistoryPage.routeName,
      builder: (context, state) => const SupportHistoryPage(),
    ),
    GoRoute(
      path: '/${SupportHistoryDetailsPage.routeName}',
      name: SupportHistoryDetailsPage.routeName,
      builder: (context, state) => SupportHistoryDetailsPage(
        history: state.extra as HistoryModel,
      ),
    ),
    GoRoute(
      path: '/${InactiveTerminalPage.routeName}',
      name: InactiveTerminalPage.routeName,
      builder: (context, state) => const InactiveTerminalPage(),
    ),
    GoRoute(
      path: '/${ActiveTerminalPage.routeName}',
      name: ActiveTerminalPage.routeName,
      builder: (context, state) => const ActiveTerminalPage(),
    ),
    GoRoute(
      path: '/${TerminalDetailsPage.routeName}',
      name: TerminalDetailsPage.routeName,
      builder: (context, state) => TerminalDetailsPage(
        terminal: state.extra as TerminalDetailRoute,
      ),
    ),
    GoRoute(
      path: '/${CreateTaskPage.routeName}',
      name: CreateTaskPage.routeName,
      builder: (context, state) => CreateTaskPage(
        terminal: state.extra as TerminalModel?,
      ),
    ),
    GoRoute(
      path: '/${ChangePasswordPage.routeName}',
      name: ChangePasswordPage.routeName,
      builder: (context, state) => const ChangePasswordPage(),
    ),
    GoRoute(
      path: '/${RoadMapPage.routeName}',
      name: RoadMapPage.routeName,
      builder: (context, state) => const RoadMapPage(),
    ),
    GoRoute(
      path: '/${ScanQrCodePage.routeName}',
      name: ScanQrCodePage.routeName,
      builder: (context, state) => ScanQrCodePage(
        taskId: state.extra as int?,
      ),
    ),
    GoRoute(
      path: '/${PhotoViewPage.routeName}',
      name: PhotoViewPage.routeName,
      builder: (context, state) => PhotoViewPage(
        url: state.extra as String,
      ),
    ),
  ],
  initialLocation: '/${LoginPage.routeName}',
  observers: [routeObserver],
  navigatorKey: navigatorKey,
  debugLogDiagnostics: true,
);

/// Route observer to use with RouteAware
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
