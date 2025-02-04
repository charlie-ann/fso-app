// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/reusables/app_util.dart';
import 'package:fso_support/core/reusables/button.dart';
import 'package:fso_support/core/reusables/textfield.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:fso_support/core/utils/extensions.dart';
import 'package:fso_support/core/utils/validators.dart';
import 'package:fso_support/dashboard.dart';
import 'package:fso_support/features/support_request/providers/support_req_prov.dart';
import 'package:fso_support/features/support_request/state/support_req_state.dart';
import 'package:go_router/go_router.dart';

class RejectTaskSheet extends ConsumerStatefulWidget {
  final String taskId;
  const RejectTaskSheet({super.key, required this.taskId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RejectTaskSheetState();
}

class _RejectTaskSheetState extends ConsumerState<RejectTaskSheet> {
  final reasonController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24),
      color: AppColors.backgroundColor,
      child: Form(
        key: _formKey,
        child: SizedBox(
          height: context.screenSize.height * 0.35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Enter Reason",
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontSize: 16.text,
                      color: const Color(0xff494E50),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xff494E50),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 14),
              AppInputField(
                label: "Reason",
                controller: reasonController,
                validator: Validators.validateField,
              ),
              const Spacer(),
              AppFilledButton(
                text: "Reject",
                isLoading: ref.watch(supReqLoadingProvider),
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());

                  if (_formKey.currentState!.validate()) {
                    await rejectTask(
                      ref: ref,
                      reason: reasonController.text,
                      taskId: widget.taskId,
                    );
                    final err = ref.watch(supReqErrorProvider);
                    if (err != null) {
                      AppUtil.showSnackBar(context, text: err, error: true);
                    } else {
                      AppUtil.showSnackBar(context,
                          text: "Task Rejected Successfully", error: false);
                      context.go("/${DashboardPage.routeName}");
                    }
                  }
                },
              ),
              const SizedBox(height: 34),
            ],
          ),
        ),
      ),
    );
  }
}
