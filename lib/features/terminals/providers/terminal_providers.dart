import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/features/terminals/datasources/terminals_ds.dart';
import 'package:fso_support/features/terminals/datasources/terminals_ds_impl.dart';
import 'package:fso_support/features/terminals/models/terminal_model.dart';
import 'package:fso_support/features/terminals/repository/terminal_repo.dart';
import 'package:fso_support/features/terminals/repository/terminal_repo_impl.dart';

final fetchedTerminal = StateProvider<TerminalModel?>((ref) => null);
final inactiveTerminalListProv =
    StateProvider<List<TerminalModel>>((ref) => []);
final inactiveTerminalSearchProv =
    StateProvider<List<TerminalModel>>((ref) => []);
final inactiveTerminalListModel =
    StateProvider<TerminalResponseModel?>((ref) => null);
final inactiveTerminalSearchModel =
    StateProvider<TerminalResponseModel?>((ref) => null);

final activeTerminalListProv = StateProvider<List<TerminalModel>>((ref) => []);
final activeTerminalSearchProv =
    StateProvider<List<TerminalModel>>((ref) => []);
final activeTerminalListModel =
    StateProvider<TerminalResponseModel?>((ref) => null);
final activeTerminalSearchModel =
    StateProvider<TerminalResponseModel?>((ref) => null);

//loading provider
final terminalLoadingProv = StateProvider<bool>((ref) => false);
final terminalLoadingProv2 = StateProvider<bool>((ref) => false);

//error provider
final terminalErrorProv = StateProvider.autoDispose<String?>((ref) => null);

// datasource provider
final terminalDsProv = Provider<TerminalDS>((ref) => TerminalDSImpl());

// repository provider
final terminalRepoProv = Provider<TerminalRepo>((ref) {
  final terminalDs = ref.watch(terminalDsProv);
  return TerminalRepoImpl(terminalDs);
});
