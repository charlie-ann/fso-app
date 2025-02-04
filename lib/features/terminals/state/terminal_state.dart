import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/core/reusables/app_util.dart';
import 'package:fso_support/features/auth/providers/auth_providers.dart';
import 'package:fso_support/features/terminals/providers/terminal_providers.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> getSingleTerminal({
  required WidgetRef ref,
  required String terminalId,
}) async {
  ref.read(terminalLoadingProv2.notifier).state = true;

  Map<String, dynamic> data = {
    "terminal_id": terminalId,
  };

  final res = await ref.watch(terminalRepoProv).getSingleTerminal(data: data);

  res.fold((l) {
    ref.read(terminalErrorProv.notifier).state = l.message;
    ref.read(terminalLoadingProv2.notifier).state = false;
  }, (r) {
    ref.read(fetchedTerminal.notifier).state = r;
    ref.read(terminalErrorProv.notifier).state = null;
    ref.read(terminalLoadingProv2.notifier).state = false;
  });
}

Future<void> fetchInactiveTerminals({
  required WidgetRef ref,
  String? search,
  bool loadMore = false,
}) async {
  ref.read(terminalLoadingProv.notifier).state = true;

  final userId = ref.read(currentUser)?.id;

  Map<String, dynamic> data = {
    "status": "inactive",
    "length": 50,
    "user_id": userId,
  };

  if (search != null && search.isNotEmpty) {
    data.addAll({
      "search": search,
    });
  }
  if (loadMore) {
    data.addAll({
      "page":
          (ref.read(inactiveTerminalListModel.notifier).state?.currentPage ??
                  1) +
              1,
    });
  }

  final res =
      await ref.watch(terminalRepoProv).fetchAssignedTerminals(data: data);

  res.fold((l) {
    ref.read(terminalErrorProv.notifier).state = l.message;
    ref.read(terminalLoadingProv.notifier).state = false;
  }, (r) {
    ref.read(terminalLoadingProv.notifier).state = false;
    if (search != null && search.isNotEmpty) {
      ref.read(inactiveTerminalSearchProv.notifier).state = r?.terminals ?? [];
      ref.read(inactiveTerminalSearchModel.notifier).state = r;
    } else {
      if (loadMore) {
        ref.read(inactiveTerminalListProv.notifier).state = [
          ...ref.read(inactiveTerminalListProv.notifier).state,
          ...r?.terminals ?? [],
        ];
      } else {
        ref.read(inactiveTerminalListProv.notifier).state = r?.terminals ?? [];
      }
      ref.read(inactiveTerminalListModel.notifier).state = r;
    }
    ref.read(terminalErrorProv.notifier).state = null;
  });
}

Future<void> fetchActiveTerminals({
  required WidgetRef ref,
  String? search,
  bool loadMore = false,
}) async {
  ref.read(terminalLoadingProv.notifier).state = true;
  final userId = ref.read(currentUser)?.id;

  Map<String, dynamic> data = {
    "status": "active",
    "length": 50,
    "user_id": userId,
  };

  if (search != null && search.isNotEmpty) {
    data.addAll({
      "search": search,
    });
  }
  if (loadMore) {
    data.addAll({
      "page":
          (ref.read(activeTerminalListModel.notifier).state?.currentPage ?? 1) +
              1,
    });
  }

  final res =
      await ref.watch(terminalRepoProv).fetchAssignedTerminals(data: data);

  res.fold((l) {
    ref.read(terminalErrorProv.notifier).state = l.message;
    ref.read(terminalLoadingProv.notifier).state = false;
  }, (r) {
    ref.read(terminalLoadingProv.notifier).state = false;
    if (search != null && search.isNotEmpty) {
      ref.read(activeTerminalSearchProv.notifier).state = r?.terminals ?? [];
      ref.read(activeTerminalSearchModel.notifier).state = r;
    } else {
      if (loadMore) {
        ref.read(activeTerminalListProv.notifier).state = [
          ...ref.read(activeTerminalListProv.notifier).state,
          ...r?.terminals ?? [],
        ];
      } else {
        ref.read(activeTerminalListProv.notifier).state = r?.terminals ?? [];
      }

      ref.read(activeTerminalListModel.notifier).state = r;
    }
    ref.read(terminalErrorProv.notifier).state = null;
  });
}

void launchMapOnAndroid({
  required double latitude,
  required double longitude,
  required BuildContext context,
  String? markerName,
}) async {
  try {
    String markerLabel = markerName == null ? "" : '($markerName)';
    final url = Uri.parse(
        'geo:$latitude,$longitude?q=$latitude,$longitude$markerLabel');

    await launchUrl(url);
  } catch (error) {
    AppUtil.showSnackBar(context, text: error.toString(), error: true);
  }
}
