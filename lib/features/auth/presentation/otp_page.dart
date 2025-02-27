import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/reusables/app_util.dart';
import 'package:fso_support/core/reusables/loader_view.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:fso_support/core/utils/extensions.dart';
import 'package:fso_support/features/auth/presentation/reset_password.dart';
import 'package:fso_support/features/auth/providers/auth_providers.dart';
import 'package:fso_support/features/auth/state/auth_state.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends ConsumerStatefulWidget {
  static const String routeName = 'otp-page';
  const OtpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  final focusedBorderColor = const Color.fromRGBO(23, 171, 144, 1);
  final fillColor = const Color.fromRGBO(243, 246, 249, 0);

  @override
  Widget build(BuildContext context) {
    return LoaderView(
      loading: ref.watch(authLoadingProvider),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: Text(
            "Enter OTP",
            style: context.textTheme.titleMedium?.copyWith(fontSize: 16.text),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.vSpacer,
                Center(
                  child: Text(
                    "Enter 6 digit OTP sent to",
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 15.text,
                      color: AppColors.bodyTextGrey,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    ref.read(resetPasswordEmail) ?? "",
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 15.text,
                      color: AppColors.black,
                    ),
                  ),
                ),
                80.vSpacer,
                Pinput(
                  controller: pinController,
                  focusNode: focusNode,
                  defaultPinTheme: defaultPinTheme,
                  length: 6,
                  separatorBuilder: (index) => const SizedBox(width: 8),
                  // validator: (value) {
                  //   return value == '2222' ? null : 'Pin is incorrect';
                  // },
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  onCompleted: (pin) {
                    debugPrint('onCompleted: $pin');
                    context.pushNamed(ResetPasswordPage.routeName, extra: pin);
                  },
                  onChanged: (value) {
                    debugPrint('onChanged: $value');
                  },
                  cursor: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 9),
                        width: 22,
                        height: 1,
                        color: focusedBorderColor,
                      ),
                    ],
                  ),
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: focusedBorderColor),
                    ),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(color: focusedBorderColor),
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyBorderWith(
                    border: Border.all(color: Colors.redAccent),
                  ),
                ),
                100.vSpacer,
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      await forgotPassword(
                        ref: ref,
                        email: ref.read(resetPasswordEmail) ?? "",
                      );
                      final err = ref.watch(authErrorProvider);
                      if (err == null) {
                        AppUtil.showSnackBar(context,
                            text: "OTP sent successfully");
                      }
                    },
                    child: Text(
                      "Resend OTP",
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontSize: 14.text,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: const Color.fromRGBO(23, 171, 144, 0.4)),
    ),
  );
}
