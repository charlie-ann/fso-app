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
import 'package:fso_support/dashboard.dart';
import 'package:fso_support/features/auth/providers/auth_providers.dart';
import 'package:fso_support/features/auth/state/auth_state.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  static const String routeName = 'change-password-page';
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isVisible1 = true;
  bool _isVisible2 = true;
  bool _isVisible3 = true;

  @override
  Widget build(BuildContext context) {
    return LoaderView(
      loading: ref.watch(authLoadingProvider),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: Text(
            "Change Password",
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
                Text(
                  "Enter your old and new passwords to change your password",
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 12.text,
                    color: AppColors.bodyTextGrey,
                  ),
                ),
                22.vSpacer,
                AppInputField(
                  label: "Old Password",
                  validator: Validators.validatePassword,
                  controller: oldPasswordController,
                  obscureText: _isVisible1,
                  suffixIcon: buildInputIcon(
                      icon:
                          _isVisible1 ? ImageStrings.eye : ImageStrings.eyeOff,
                      onTap: () {
                        setState(() {
                          _isVisible1 = !_isVisible1;
                        });
                      }),
                ),
                16.vSpacer,
                AppInputField(
                  label: "New Password",
                  validator: Validators.validatePassword,
                  controller: newPasswordController,
                  obscureText: _isVisible2,
                  suffixIcon: buildInputIcon(
                      icon:
                          _isVisible2 ? ImageStrings.eye : ImageStrings.eyeOff,
                      onTap: () {
                        setState(() {
                          _isVisible2 = !_isVisible2;
                        });
                      }),
                ),
                16.vSpacer,
                AppInputField(
                  label: "Confirm New Password",
                  validator: (val) {
                    if (val != newPasswordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                  obscureText: _isVisible3,
                  suffixIcon: buildInputIcon(
                      icon:
                          _isVisible3 ? ImageStrings.eye : ImageStrings.eyeOff,
                      onTap: () {
                        setState(() {
                          _isVisible3 = !_isVisible3;
                        });
                      }),
                ),
                80.vSpacer,
                AppFilledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await changePassword(
                        ref: ref,
                        oldPass: oldPasswordController.text,
                        newPass: newPasswordController.text,
                      );
                      final err = ref.read(authErrorProvider);
                      if (err != null) {
                        AppUtil.showSnackBar(context, text: err, error: true);
                      } else {
                        await getUser(ref: ref);
                        AppUtil.showSnackBar(context,
                            text: "Password Changed Successfully",
                            error: false);
                        context.pushNamed(DashboardPage.routeName);
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
