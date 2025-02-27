import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/constants/image_strings.dart';
import 'package:fso_support/core/reusables/app_util.dart';
import 'package:fso_support/core/reusables/button.dart';
import 'package:fso_support/core/reusables/loader_view.dart';
import 'package:fso_support/core/reusables/textfield.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:fso_support/core/storage/storage.dart';
import 'package:fso_support/core/utils/extensions.dart';
import 'package:fso_support/core/utils/validators.dart';
import 'package:fso_support/dashboard.dart';
import 'package:fso_support/features/auth/presentation/forgot_password.dart';
import 'package:fso_support/features/auth/providers/auth_providers.dart';
import 'package:fso_support/features/auth/state/auth_state.dart';
import 'package:fso_support/features/history/state/history_state.dart';
import 'package:fso_support/features/log_support/state/log_support_state.dart';
import 'package:fso_support/features/support_request/state/support_req_state.dart';
import 'package:fso_support/features/terminals/state/terminal_state.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const String routeName = 'login-page';
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isVisible = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storage = StorageImpl();
      storage.getEmail().then((value) {
        if (value != null) {
          emailController.text = value;
        }
      });
      storage.getPassword().then((value) {
        if (value != null) {
          passwordController.text = value;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderView(
      loading: ref.watch(authLoadingProvider),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                40.vSpacer,
                Row(
                  children: [
                    Container(
                      height: 19,
                      width: 19,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Text(
                      "ITEX FIELD APPLICATION",
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontSize: 12.text,
                        color: AppColors.bodyTextGrey,
                      ),
                    ),
                  ],
                ),
                40.vSpacer,
                Text(
                  "Sign in to your Account",
                  style: context.textTheme.titleMedium?.copyWith(
                    fontSize: 32.text,
                  ),
                ),
                8.vSpacer,
                Text(
                  "Enter your email and password to log in ",
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 12.text,
                    color: AppColors.bodyTextGrey,
                  ),
                ),
                22.vSpacer,
                AppInputField(
                  label: "Email",
                  validator: Validators.validateEmail,
                  controller: emailController,
                ),
                16.vSpacer,
                AppInputField(
                  label: "Password",
                  validator: Validators.validatePassword,
                  controller: passwordController,
                  obscureText: _isVisible,
                  suffixIcon: buildInputIcon(
                      icon: _isVisible ? ImageStrings.eye : ImageStrings.eyeOff,
                      onTap: () {
                        setState(() {
                          _isVisible = !_isVisible;
                        });
                      }),
                ),
                46.vSpacer,
                AppFilledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await login(
                        ref: ref,
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      final err = ref.read(authErrorProvider);
                      if (err != null) {
                        AppUtil.showSnackBar(context, text: err, error: true);
                      } else {
                        fetchHistory(ref: ref);
                        fetchInactiveTerminals(ref: ref);
                        fetchSupportRequest(ref: ref);
                        fetchRoadMap(ref: ref);
                        fetchStates(ref);
                        fetchBanks(ref);
                        context.go("/${DashboardPage.routeName}");
                      }
                    }
                  },
                  text: "Log In",
                ),
                16.vSpacer,
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      context.pushNamed(ForgotPasswordPage.routeName);
                    },
                    child: Text(
                      "Forgot Password?",
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontSize: 12.text,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
