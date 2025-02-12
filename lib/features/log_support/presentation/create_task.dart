import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/constants/image_strings.dart';
import 'package:fso_support/core/reusables/app_util.dart';
import 'package:fso_support/core/reusables/appbar.dart';
import 'package:fso_support/core/reusables/button.dart';
import 'package:fso_support/core/reusables/drop_down.dart';
import 'package:fso_support/core/reusables/loader_view.dart';
import 'package:fso_support/core/reusables/textfield.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:fso_support/core/utils/extensions.dart';
import 'package:fso_support/core/utils/validators.dart';
import 'package:fso_support/dashboard.dart';
import 'package:fso_support/features/auth/providers/auth_providers.dart';
import 'package:fso_support/features/log_support/model/log_support.dart';
import 'package:fso_support/features/log_support/presentation/qr_scanner.dart';
import 'package:fso_support/features/log_support/providers/log_support_prov.dart';
import 'package:fso_support/features/log_support/state/log_support_state.dart';
import 'package:fso_support/features/support_request/presentation/support_details_page.dart';
import 'package:fso_support/features/support_request/state/support_req_state.dart';
import 'package:fso_support/features/terminals/models/terminal_model.dart';
import 'package:fso_support/features/terminals/providers/terminal_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class CreateTaskPage extends ConsumerStatefulWidget {
  static const String routeName = 'create-task-page';
  final TerminalModel? terminal;
  const CreateTaskPage({super.key, this.terminal});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends ConsumerState<CreateTaskPage> {
  final tidController = TextEditingController();
  final merchantController = TextEditingController();
  final telephoneController = TextEditingController();
  final addressController = TextEditingController();
  final issueController = TextEditingController();
  final areaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<File> terminalImages = [];

  List<String> supportTypeList = [
    "SOS Support Request",
    "Roadmap visitation",
    "Re-visitation"
  ];
  String? selectedSupportType;

  String? selectedState;

  @override
  void initState() {
    if (widget.terminal != null) {
      setState(() {
        tidController.text = widget.terminal?.terminalId ?? "";
        merchantController.text = widget.terminal?.merchantName ?? "";
        addressController.text = widget.terminal?.address ?? "";
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchStates(ref);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderView(
      loading:
          ref.watch(terminalLoadingProv2) || ref.watch(logSupportLoadingProv),
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 100,
          leading: AppBackButton(
            onTap: () {
              context.pop();
            },
          ),
          title: Text(
            "Create Support Task",
            style: context.textTheme.displayLarge?.copyWith(
              fontSize: 16.text,
              color: AppColors.blackText,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.black.withOpacity(.05)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppInputField(
                        label: "Merchant Name:",
                        controller: merchantController,
                        validator: Validators.validateField,
                      ),
                      23.vSpacer,
                      AppInputField(
                        label: "Terminal ID:",
                        controller: tidController,
                        validator: Validators.validateField,
                      ),
                      23.vSpacer,
                      AppDropDown(
                        label: "State:",
                        data: ref.watch(stateListProv),
                        selectedValue: selectedState,
                        onChanged: (p0) => setState(() {
                          selectedState = p0;
                        }),
                        validator: Validators.validateField,
                      ),
                      23.vSpacer,
                      AppInputField(
                        label: "Area:",
                        controller: areaController,
                        validator: Validators.validateField,
                      ),
                      23.vSpacer,
                      AppInputField(
                        label: "Address:",
                        controller: addressController,
                        validator: Validators.validateField,
                      ),

                      23.vSpacer,
                      AppInputField(
                        label: "Telephone:",
                        controller: telephoneController,
                        validator: Validators.validateField,
                        textInputType: TextInputType.phone,
                      ),
                      23.vSpacer,
                      AppInputField(
                        label: "Support Issue:",
                        controller: issueController,
                        validator: Validators.validateField,
                      ),
                      23.vSpacer,
                      AppDropDown(
                        label: "Support Type:",
                        data: supportTypeList,
                        selectedValue: selectedSupportType,
                        onChanged: (p0) => setState(() {
                          selectedSupportType = p0;
                        }),
                        validator: Validators.validateField,
                      ),
                      23.vSpacer,
                      GestureDetector(
                        onTap: () {
                          snapTerminal();
                        },
                        child: terminalImages.isEmpty
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(.1),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(.1),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    50.vSpacer,
                                    Image.asset(
                                      ImageStrings.upload,
                                      height: 28,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Take a picture of the terminal",
                                      style:
                                          context.textTheme.bodySmall?.copyWith(
                                        color:
                                            AppColors.primary.withOpacity(.6),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ))
                            : Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      onPressed: () {
                                        snapTerminal();
                                      },
                                      icon: const Icon(
                                        Icons.add_a_photo,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.only(
                                        left: 1, right: 1, top: 5),
                                    itemCount: terminalImages.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: Platform.isIOS ? 5 : 8,
                                      childAspectRatio: 1,
                                      mainAxisExtent: 85,
                                    ),
                                    itemBuilder: (context, index) {
                                      final terminalImage =
                                          terminalImages[index];
                                      return Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              terminalImage,
                                              height: 100,
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: InkWell(
                                              onTap: () {
                                                terminalImages.removeAt(index);
                                                setState(() {});
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                decoration: const BoxDecoration(
                                                  color:
                                                      AppColors.lightGreyText,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: AppColors.errorRed,
                                                  size: 12,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                      ),
                      50.vSpacer,
                      AppFilledButton(
                        onPressed: () async {
                          // taskId = ref.watch(fetchedTerminal)?.id;
                          if (_formKey.currentState!.validate()) {
                            if (terminalImages.isEmpty) {
                              AppUtil.showSnackBar(context,
                                  text: "Please take a picture of the terminal",
                                  error: true);
                              return;
                            }
                            final res = await createTask(
                              ref,
                              LogSupportParams(
                                document: terminalImages,
                                merchantName: merchantController.text,
                                phoneNumber: telephoneController.text,
                                purpose: issueController.text,
                                supportType: selectedSupportType,
                                terminalId: tidController.text,
                                address: addressController.text,
                                fsoId: ref.watch(currentUser)?.id.toString(),
                                state: selectedState,
                                area: areaController.text,
                              ),
                            );

                            final err = ref.read(logSupportErrorProvider);
                            if (err != null) {
                              AppUtil.showSnackBar(context,
                                  text: err, error: true);
                            } else {
                              await fetchSupportRequest(ref: ref);

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  insetPadding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  contentPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  content: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          10.vSpacer,
                                          Text(
                                            "Task Created Successfully, Would you like to Complete the Task?",
                                            style: context.textTheme.bodyMedium
                                                ?.copyWith(
                                              fontSize: 14.text,
                                              color: AppColors.blackText,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          44.vSpacer,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              buildDialogButton(
                                                context,
                                                text: "Yes",
                                                color: AppColors.successGreen,
                                                onTap: () {
                                                  context.pop();
                                                  context.pushNamed(
                                                    ScanQrCodePage.routeName,
                                                    extra: QrRouteParams(
                                                      taskId: res,
                                                    ),
                                                  );
                                                },
                                              ),
                                              const SizedBox(width: 17),
                                              buildDialogButton(
                                                context,
                                                text: "Go Home",
                                                color: AppColors.errorRed,
                                                onTap: () => context.go(
                                                    "/${DashboardPage.routeName}"),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        text: "Submit",
                      ),
                      // Container(
                      //   padding:
                      //       const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      //   decoration: BoxDecoration(
                      //     color: AppColors.bodyTextGrey.withOpacity(.1),
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: Column(
                      //     // crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           Image.asset(
                      //             ImageStrings.locationIcon,
                      //             height: 11,
                      //           ),
                      //           const SizedBox(width: 4.5),
                      //           Text(
                      //             "Location",
                      //             style: context.textTheme.bodySmall?.copyWith(
                      //               color: AppColors.blackText,
                      //               fontSize: 8,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       AppSwitch(
                      //         enabled: isLocation,
                      //         alignment: Alignment.centerLeft,
                      //         onChanged: (val) {
                      //           setState(() {
                      //             isLocation = val;
                      //           });
                      //         },
                      //       )
                      //     ],
                      //   ),
                      // ),
                      50.vSpacer,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> snapTerminal() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxHeight: 200,
      maxWidth: 200,
    );

    if (image != null) {
      terminalImages.add(File(image.path));
      setState(() {});
    }
  }
}
