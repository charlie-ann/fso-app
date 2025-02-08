class AppEndpoints {
  static const testBaseUrl = 'http://197.253.19.78:7050/'; //test
  static const baseUrl = 'http://197.253.19.78:7050/';

  //auth
  static const login = "auth/login";
  static const changedPassword = "auth/change-password";
  static const resetPassword = "auth/reset-password";
  static const forgotPassword = "auth/forgot-password";
  static const getUser = "auth/users/me";
  static const fetchStates = "auth/states";
  static const clockIn = "logins";

  //support
  static const logSupport = "support/log";
  static const fetchSupportRequest = "tasks";
  static const createTask = "tasks";
  static const fetchBanks = "support/banks";
  static const uniformReport = "support/uniform-report";

  //terminal
  static const getSingleTerminal = "terminals/lookup";
  static const getInactiveTerminal = "terminals";
  static const getAssignedTerminals = "terminals/assigned";
}
