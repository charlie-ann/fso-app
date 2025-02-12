import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:fso_support/core/utils/input_formatters.dart';
import 'package:fso_support/core/utils/validators.dart';
import 'package:fso_support/dashboard.dart';
import 'package:fso_support/features/history/state/history_state.dart';
import 'package:fso_support/features/log_support/model/log_support.dart';
import 'package:fso_support/features/log_support/presentation/create_task.dart';
import 'package:fso_support/features/log_support/providers/log_support_prov.dart';
import 'package:fso_support/features/log_support/state/log_support_state.dart';
import 'package:fso_support/features/terminals/models/terminal_model.dart';
import 'package:fso_support/features/terminals/providers/terminal_providers.dart';
import 'package:fso_support/features/terminals/state/terminal_state.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

class LogSupportPage extends ConsumerStatefulWidget {
  static const String routeName = 'log-support-page';
  final TerminalParams? terminal;
  const LogSupportPage({super.key, this.terminal});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LogSupportPageState();
}

class _LogSupportPageState extends ConsumerState<LogSupportPage> {
  int index = 0;
  bool isLocation = true;

  final tidController = TextEditingController();
  final merchantController = TextEditingController();
  final telephoneController = TextEditingController();
  final stateController = TextEditingController();
  final addressController = TextEditingController();
  final busTypeController = TextEditingController();
  final networkController = TextEditingController();
  final serialController = TextEditingController();
  final simSerialController = TextEditingController();
  final terminalTypeController = TextEditingController();
  final appVersionController = TextEditingController();
  final purposeController = TextEditingController();
  final othersController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final SignatureController signController = SignatureController(
    penStrokeWidth: 1.5,
    penColor: AppColors.primary,
    exportBackgroundColor: Colors.white,
    exportPenColor: AppColors.primary,
  );

  File? signatureImage;
  List<File> terminalImages = [];

  List<String> supportStatusList = ["Unresolved", "Successful"];
  String? selectedSupportStatus;

  List<String> terminalStatusList = ["Active", "InActive"];
  String? selectedTerminalStatus;

  String? selectedReport;

  String? selectedBank;
  List<String> bankList = [];

  List<String> supportTypeList = [
    "SOS Support Request",
    "Roadmap visitation",
    "Re-visitation",
    "Others",
  ];
  String? selectedSupportType;
  String logType = "manual";

  final _formKey1 = GlobalKey<FormState>();

  @override
  void initState() {
    signController.addListener(() {});
    selectedSupportType = widget.terminal?.supportReqType;
    if (widget.terminal?.terminalModel != null) {
      setState(() {
        index = 1;
        logType = "scanned";
        tidController.text = widget.terminal?.terminalModel?.terminalId ?? "";
        merchantController.text =
            widget.terminal?.terminalModel?.merchantName ?? "";
        terminalTypeController.text =
            widget.terminal?.terminalModel?.type ?? "";
        appVersionController.text =
            widget.terminal?.terminalModel?.appVersion ?? "";
        serialController.text =
            widget.terminal?.terminalModel?.serialNumber ?? "";
        addressController.text = widget.terminal?.terminalModel?.address ?? "";
        selectedTerminalStatus = widget.terminal?.terminalModel?.status ?? "";
      });
    }
    if (widget.terminal?.tid != null) {
      setState(() {
        tidController.text = widget.terminal?.tid ?? "";
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBanks(ref).then((val) {
        bankList = val;
      });
      setState(() {});
      fetchUniformReport(ref).then((val) {
        reportList = val;
      });
      setState(() {});
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
              if (widget.terminal?.terminalModel != null) {
                context.pushNamed(DashboardPage.routeName);
              } else {
                switch (index) {
                  case 0:
                    context.pop();
                    break;
                  case 1:
                    setState(() {
                      index = 0;
                    });
                    break;
                  case 2:
                    setState(() {
                      index = 1;
                    });
                    break;
                  default:
                }
              }
            },
          ),
          title: index == 0
              ? null
              : Text(
                  "Log Support",
                  style: context.textTheme.displayLarge?.copyWith(
                    fontSize: 16.text,
                    color: AppColors.blackText,
                  ),
                ),
        ),
        body: IndexedStack(
          index: index,
          children: [
            buildPage0(),
            buildPage1(),
            buildPage2(),
          ],
        ),
      ),
    );
  }

  buildPage0() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.black.withOpacity(.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (widget.terminal?.isCreateTask == true)
                        ? "Create Support Task"
                        : "Log Support",
                    style: context.textTheme.displayLarge?.copyWith(
                      fontSize: 16.text,
                      color: AppColors.blackText,
                    ),
                  ),
                  32.vSpacer,
                  AppInputField(
                    label: "T.I.D:",
                    controller: tidController,
                    validator: Validators.validateField,
                  ),
                  32.vSpacer,
                ],
              ),
            ),
            40.vSpacer,
            Center(
              child: AppFilledButton(
                width: 280,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await getSingleTerminal(
                        ref: ref, terminalId: tidController.text);
                    final err = ref.watch(terminalErrorProv);
                    if (err != null) {
                      AppUtil.showSnackBar(context, text: err, error: true);
                    } else {
                      final terminal = ref.watch(fetchedTerminal);
                      if (terminal == null) {
                        return;
                      }
                      if (widget.terminal?.isCreateTask == true) {
                        context.pushNamed(CreateTaskPage.routeName,
                            extra: terminal);
                      } else {
                        setState(() {
                          index = 1;
                          merchantController.text = terminal.merchantName ?? "";
                          terminalTypeController.text = terminal.type ?? "";
                          appVersionController.text = terminal.appVersion ?? "";
                          serialController.text = terminal.serialNumber ?? "";
                          addressController.text = terminal.address ?? "";
                          selectedTerminalStatus = terminal.status ?? "";
                        });
                      }
                    }
                  }
                },
                text: "Proceed to Log",
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildPage1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Form(
        key: _formKey1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
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
                  AppInputField(
                    label: "Address:",
                    controller: addressController,
                    validator: Validators.validateField,
                  ),
                  23.vSpacer,
                  AppInputField(
                    label: "Terminal Type:",
                    controller: terminalTypeController,
                    validator: Validators.validateField,
                  ),
                  23.vSpacer,
                  AppInputField(
                    label: "App Version:",
                    controller: appVersionController,
                    validator: Validators.validateField,
                  ),
                  23.vSpacer,
                  AppDropDown(
                    label: "Bank Name:",
                    data: bankList,
                    selectedValue: selectedBank,
                    onChanged: (p0) => setState(() {
                      selectedBank = p0;
                    }),
                    validator: Validators.validateField,
                  ),

                  23.vSpacer,
                  AppDropDown(
                    label: "Terminal Status:",
                    data: terminalStatusList,
                    selectedValue: selectedTerminalStatus,
                    onChanged: (p0) => setState(() {
                      selectedTerminalStatus = p0;
                    }),
                    validator: Validators.validateField,
                  ),
                  23.vSpacer,
                  AppInputField(
                    label: "Sim Serial:",
                    controller: simSerialController,
                    validator: Validators.validateField,
                  ),
                  23.vSpacer,
                  AppInputField(
                    label: "Serial Number:",
                    controller: serialController,
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
                    label: "Business Type:",
                    controller: busTypeController,
                    validator: Validators.validateField,
                  ),
                  23.vSpacer,
                  AppInputField(
                    label: "Network:",
                    controller: networkController,
                    validator: Validators.validateField,
                  ),
                  23.vSpacer,
                  AppInputField(
                    label: "Purpose of Support:",
                    controller: purposeController,
                    validator: Validators.validateField,
                  ),
                  if (widget.terminal?.supportReqType == null) ...[
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
                  ],
                  23.vSpacer,
                  AppDropDown(
                    label: "Support Status:",
                    data: supportStatusList,
                    selectedValue: selectedSupportStatus,
                    onChanged: (p0) => setState(() {
                      selectedSupportStatus = p0;
                    }),
                    validator: Validators.validateField,
                  ),
                  23.vSpacer,
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Text(
                      "Uniform Report:",
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontSize: 12.text,
                        color: AppColors.bodyTextGrey,
                      ),
                    ),
                  ),
                  StatefulBuilder(
                    builder: (context, setstate) {
                      return DropdownSearch<String>(
                        validator: Validators.validateField,
                        items: (filter, infiniteScrollProps) => reportList,
                        selectedItem: selectedReport,
                        dropdownBuilder: (context, selectedItem) => Text(
                          selectedItem ?? "",
                          style: context.textTheme.bodySmall,
                        ),
                        suffixProps: const DropdownSuffixProps(
                          dropdownButtonProps: DropdownButtonProps(
                            iconClosed: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 24,
                              color: AppColors.bodyTextGrey,
                            ),
                          ),
                        ),
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: searchFieldProps(),
                          menuProps: const MenuProps(
                            backgroundColor: Colors.white,
                          ),
                        ),
                        onChanged: (value) async {
                          selectedReport = value;
                        },
                        decoratorProps: DropDownDecoratorProps(
                          baseStyle: context.textTheme.bodySmall?.copyWith(),
                          decoration: InputDecoration(
                            labelStyle: context.textTheme.bodySmall?.copyWith(),
                          ),
                        ),
                      );
                    },
                  ),
                  23.vSpacer,
                  AppInputField(
                    label: "Others:",
                    controller: othersController,
                  ),
                  if (logType != "scanned") ...[
                    23.vSpacer,
                    GestureDetector(
                      onTap: () => setState(() {
                        index = 2;
                      }),
                      child: AbsorbPointer(
                        absorbing: true,
                        child: AppInputField(
                          label: "Merchant’s Signature",
                          hintText: signatureImage == null
                              ? "Click here to draw signature"
                              : signatureImage?.path ?? "",
                        ),
                      ),
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
                                      color: AppColors.primary.withOpacity(.6),
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
                                  physics: const NeverScrollableScrollPhysics(),
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
                                    final terminalImage = terminalImages[index];
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
                                              padding: const EdgeInsets.all(2),
                                              decoration: const BoxDecoration(
                                                color: AppColors.lightGreyText,
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
                  ],
                  50.vSpacer,
                  AppFilledButton(
                    onPressed: () async {
                      await getCurrentLocation(ref);
                      final currentLoc = ref.watch(currentLocation);
                      if (currentLoc == null) {
                        log("message");
                        return;
                      }
                      // taskId = ref.watch(fetchedTerminal)?.id;
                      if (_formKey1.currentState!.validate()) {
                        if ((logType != "scanned")
                            ? (terminalImages.isEmpty || signatureImage == null)
                            : false) {
                          AppUtil.showSnackBar(context,
                              text:
                                  "Please take a picture of the terminal and signature",
                              error: true);
                          return;
                        }
                        await logSupport(
                          ref,
                          LogSupportParams(
                            appVersion: appVersionController.text,
                            businessType: busTypeController.text,
                            document: terminalImages,
                            signature: signatureImage,
                            lat: currentLoc.latitude.toString(),
                            lng: currentLoc.longitude.toString(),
                            merchantName: merchantController.text,
                            network: networkController.text,
                            phoneNumber: telephoneController.text,
                            purpose: purposeController.text,
                            serialNumber: serialController.text,
                            simSerial: simSerialController.text,
                            state: selectedTerminalStatus,
                            supportType: selectedSupportType,
                            taskId: widget.terminal?.taskId,
                            terminalId: tidController.text,
                            type: terminalTypeController.text,
                            logType: logType,
                            bankName: selectedBank,
                            supportStatus: selectedSupportStatus,
                            uniformReport: selectedReport,
                            others: othersController.text,
                          ),
                        );

                        final err = ref.read(logSupportErrorProvider);
                        if (err != null) {
                          AppUtil.showSnackBar(context, text: err, error: true);
                        } else {
                          await fetchHistory(ref: ref);
                          AppUtil.showSnackBar(context,
                              text: "Support Submitted Successfully");
                          context.pushNamed(DashboardPage.routeName);
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
    );
  }

  buildPage2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.black.withOpacity(.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Merchant Signature",
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 12.text,
                    color: AppColors.bodyTextGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 300,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(.4),
                      width: .4,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Signature(
                        controller: signController,
                        backgroundColor: Colors.white),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      ImageStrings.cautionIcon,
                      height: 26,
                    ),
                    Text(
                      "Draw out your signature with\nyour finger",
                      style: context.textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: AppColors.blackText.withOpacity(.7),
                      ),
                    ),
                  ],
                ),
                30.vSpacer,
                Container(
                  decoration:
                      const BoxDecoration(color: AppColors.backgroundColor),
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.clear),
                        color: AppColors.errorRed,
                        onPressed: () {
                          setState(() => signController.clear());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.undo),
                        color: AppColors.primary,
                        onPressed: () {
                          setState(() => signController.undo());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.redo),
                        color: AppColors.primary,
                        onPressed: () {
                          setState(() => signController.redo());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.check),
                        color: AppColors.primary,
                        onPressed: () async {
                          if (signController.isNotEmpty) {
                            final Uint8List? data =
                                await signController.toPngBytes();
                            final tempDir = await getTemporaryDirectory();
                            signatureImage = await File(
                                    "${tempDir.path}/${DateTime.now().toString()}.png")
                                .create();
                            if (signatureImage != null) {
                              signatureImage!.writeAsBytesSync(data!.toList());
                            }
                            setState(() {
                              index = 1;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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

  List<String> reportList = [
    allFirstToUpper("ACCESS DENIED"),
    allFirstToUpper("ACCOUNT RELATED ISSUE"),
    allFirstToUpper("APPLICATION ISSUE"),
    allFirstToUpper("APPLICATION NEEDS RELOAD"),
    allFirstToUpper("APPLICATION NEEDS UPGRADE"),
    allFirstToUpper("BAD CARD READER RETRIEVED BY ITEX FOR REPAIR"),
    allFirstToUpper("BAD CHARGING PORT RETRIEVED BY ITEX FOR REPAIR"),
    allFirstToUpper("BAD KEY PAD RETRIEVED BY ITEX FOR REPAIR"),
    allFirstToUpper("BAD MAINBOARD"),
    allFirstToUpper("BAD PRINTER RETRIEVED BY ITEX FOR REPAIR"),
    allFirstToUpper("BAD SAMBOARD"),
    allFirstToUpper("BAD SCREEN RETRIEVED BY ITEX FOR REPAIR"),
    allFirstToUpper("BUILDING DEMOLISHED"),
    allFirstToUpper("BUILDING UNDER RENOVATION"),
    allFirstToUpper("BUSINESS CLOSED DOWN"),
    allFirstToUpper("BUSINESS CLOSED DOWN TEMPORARILY"),
    allFirstToUpper("CHARGE BACK ISSUES"),
    allFirstToUpper("FAULTY TERMINAL (EXACT ISSUE)"),
    allFirstToUpper("HIGH BANK CHARGES"),
    allFirstToUpper("HOSTILE MERCHANT"),
    allFirstToUpper("INCOMPLETE ADDRESS, NO PHONE NUMBER"),
    allFirstToUpper("INCOMPLETE ADDRESS, WRONG PHONE NUMBER"),
    allFirstToUpper("ISSUER OR SWITCH INOPERATIVE"),
    allFirstToUpper("LOW PATRONAGE"),
    allFirstToUpper("MASTERKEY FAILED"),
    allFirstToUpper("MERCHANT CLAIMS NOT TO HAVE POS"),
    allFirstToUpper("MERCHANT CLAIMS OWNERSHIP OF THE TERMINAL"),
    allFirstToUpper(
        "MERCHANT COMPLAINED OF DEBITING AND DECLINED TRANSACTIONS"),
    allFirstToUpper("WITHOUT REVERSAL"),
    allFirstToUpper("MERCHANT IS DECEASED"),
    allFirstToUpper("MERCHANT IS ON HOLIDAY"),
    allFirstToUpper("MERCHANT NEEDS NOTICE FROM THE BANK"),
    allFirstToUpper("MERCHANT NOT AROUND AT THE TIME OF VISIT"),
    allFirstToUpper("MERCHANT NOT INTERESTED IN USING POS AGAIN"),
    allFirstToUpper("MERCHANT REJECTED POS"),
    allFirstToUpper("MERCHANT RELOCATED, ADDRESS PROVIDED"),
    allFirstToUpper("MERCHANT RELOCATED, NO ADDRESS PROVIDED"),
    allFirstToUpper("MERCHANT TRAVELLED"),
    allFirstToUpper("MERCHANT WANTS POS CHANGED"),
    allFirstToUpper("MISPLACED POS"),
    allFirstToUpper("NETWORK ISSUE"),
    allFirstToUpper("OK(BRINGAFRICA)"),
    allFirstToUpper("OK(CITISERVE)"),
    allFirstToUpper("OK(EVOLUTION)"),
    allFirstToUpper("OK(EXPRESS PAYMENT)"),
    allFirstToUpper("OK(GLOBAL ACCERELEX)"),
    allFirstToUpper("OK(INTERSWITCH)"),
    allFirstToUpper("OK(ITEX APP)"),
    allFirstToUpper("OK(NETOP)"),
    allFirstToUpper("OK(UPSL)"),
    allFirstToUpper("POS IS USED OCCASSIONALLY"),
    allFirstToUpper("POS IS USED ROTATIONALLY"),
    allFirstToUpper("POS NOT COMING UP"),
    allFirstToUpper("POS NOT COMING UP RETRIEVED BY ITEX FOR REPAIR"),
    allFirstToUpper("POS NOT IN USE"),
    allFirstToUpper("POS TAMPERED RETRIEVED BY ITEX FOR REPAIR"),
    allFirstToUpper("ROUTING ERROR AT THE POINT OF PREPPING"),
    allFirstToUpper("ROUTING ERROR AT THE POINT OF TRANSACTION"),
    allFirstToUpper("SCHOOL IS ON STRIKE"),
    allFirstToUpper("SCHOOL IS ON VACATION"),
    allFirstToUpper("SEE NEW ADDRESS"),
    allFirstToUpper("SETTLEMENT ISSUE"),
    allFirstToUpper("SETTLEMENT ISSUE AND BAD BATTERY"),
    allFirstToUpper("SETTLEMENT ISSUE AND CHARGE BACK ISSUE"),
    allFirstToUpper("SETTLEMENT ISSUE AND HIGH CHARGES"),
    allFirstToUpper("SETTLEMENT ISSUE AND NO CHARGER"),
    allFirstToUpper("SIM IS OUT OF DATA"),
    allFirstToUpper("SPECIAL EVENT POS"),
    allFirstToUpper("STAMP DUTY"),
    allFirstToUpper("STOLEN POS"),
    allFirstToUpper("SUCCESSFULLY SUPPORTED"),
    allFirstToUpper("TERMINAL NEEDS REPLACEMENT"),
    allFirstToUpper("TERMINAL NOT FOUND AT THE LOCATION"),
    allFirstToUpper("TERMINAL NOT YET DEPLOYED"),
    allFirstToUpper("TERMINAL RETRIEVED AND REMAPPED"),
    allFirstToUpper("TERMINAL RETRIEVED AND REPLACED WITH ANOTHER PTAD APP"),
    allFirstToUpper("TERMINAL RETRIEVED BY BANK DUE TO NON USAGE"),
    allFirstToUpper("TERMINAL RETRIEVED BY BANK FOR REPAIR"),
    allFirstToUpper("TERMINAL RETRIEVED BY BANK FOR REPLACEMENT"),
    allFirstToUpper("TERMINAL RETRIEVED BY BANK PERMANENTLY"),
    allFirstToUpper("TERMINAL RETRIEVED BY ITEX FOR REPAIR"),
    allFirstToUpper("TERMINAL RETRIEVED BY ITEX FOR UPGRADE"),
    allFirstToUpper("TERMINAL RETRIEVED BY ITEX PERMANENTLY"),
    allFirstToUpper("UNABLE TO LOCATE, CONTACT NUMBER NOT REACHABLE"),
    allFirstToUpper("UNABLE TO LOCATE, MERCHANT NOT FOUND AT THE LOCATION"),
    allFirstToUpper("UNABLE TO LOCATE, WRONG ADDRESS AND NUMBER"),
    allFirstToUpper("UNCREDITTED FUNDS"),
    allFirstToUpper("VISIT RESCHEDULED WITH MERCHANT "),
  ];
  searchFieldProps() {
    return TextFieldProps(
      cursorColor: AppColors.bodyTextGrey,
      cursorWidth: 1,
      style: context.textTheme.bodySmall,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.borderGrey,
            width: 1,
          ),
        ),
        isDense: true,
      ),
    );
  }
}
