import 'package:fso_support/features/terminals/models/terminal_model.dart';

abstract class TerminalDS {
  Future<TerminalModel?> getSingleTerminal(
      {required Map<String, dynamic> data});
  Future<TerminalResponseModel?> fetchInactiveTerminals(
      {required Map<String, dynamic> data});
  Future<TerminalResponseModel?> fetchAssignedTerminals(
      {required Map<String, dynamic> data});
}
