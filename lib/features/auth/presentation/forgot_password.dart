import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/constants/image_strings.dart';
import 'package:fso_support/core/reusables/app_util.dart';
import 'package:fso_support/core/reusables/button.dart';
import 'package:fso_support/core/reusables/loader_view.dart';
import 'package:fso_support/core/reusables/textfield.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:fso_support/core/utils/extensions.dart';
import 'package:fso_support/core/utils/validators.dart';
import 'package:fso_support/features/auth/presentation/otp_page.dart';
import 'package:fso_support/features/auth/providers/auth_providers.dart';
import 'package:fso_support/features/auth/state/auth_state.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  static const String routeName = 'forgot-password-page';
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LoaderView(
      loading: ref.watch(authLoadingProvider),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: Text(
            "Forgot Password",
            style: context.textTheme.titleMedium?.copyWith(fontSize: 16.text),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(ImageStrings.forgotPassword),
                16.vSpacer,
                Text(
                  "Enter your email address to reset your password",
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 15.text,
                    color: AppColors.bodyTextGrey,
                  ),
                ),
                22.vSpacer,
                AppInputField(
                  label: "Email Address",
                  validator: Validators.validateEmail,
                  controller: emailController,
                ),
                80.vSpacer,
                AppFilledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await forgotPassword(
                        ref: ref,
                        email: emailController.text,
                      );
                      final err = ref.read(authErrorProvider);
                      if (err != null) {
                        AppUtil.showSnackBar(context, text: err, error: true);
                      } else {
                        context.pushNamed(OtpPage.routeName);
                      }
                    }
                  },
                  text: "Submit",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
