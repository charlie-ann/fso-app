import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/reusables/app_util.dart';
import 'package:fso_support/core/reusables/appbar.dart';
import 'package:fso_support/core/reusables/button.dart';
import 'package:fso_support/core/reusables/loader_view.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:fso_support/core/utils/extensions.dart';
import 'package:fso_support/features/log_support/presentation/log_support.dart';
import 'package:fso_support/features/log_support/providers/log_support_prov.dart';
import 'package:fso_support/features/terminals/models/terminal_model.dart';
import 'package:fso_support/features/terminals/providers/terminal_providers.dart';
import 'package:fso_support/features/terminals/state/terminal_state.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrCodePage extends ConsumerStatefulWidget {
  static const String routeName = "scan-qr-code-page";
  const ScanQrCodePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScanQrCodePageState();
}

class _ScanQrCodePageState extends ConsumerState<ScanQrCodePage> {
  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );
  List<Barcode> scannedBarcodes = [];

  bool isVisible = false;

  String? time;
  String? date;
  String? tid;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context)
          .topCenter(Offset(0, context.screenSize.height * 0.35)),
      width: 250.relHeight,
      height: 250.relHeight,
    );

    return LoaderView(
      loading: ref.watch(terminalLoadingProv2),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          leadingWidth: 100,
          leading: const AppBackButton(),
          title: Text(
            "Scan QR Code",
            style: context.textTheme.displayLarge?.copyWith(
              fontSize: 16.text,
              color: AppColors.blackText,
            ),
          ),
          actions: [
            ToggleFlashlightButton(controller: controller),
          ],
        ),
        body: Stack(
          children: [
            Center(
              child: MobileScanner(
                fit: BoxFit.fill,
                controller: controller,
                scanWindow: scanWindow,
                errorBuilder: (context, error, child) {
                  return ScannerErrorWidget(error: error);
                },
                overlayBuilder: (context, constraints) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: StreamBuilder(
                        stream: controller.barcodes,
                        builder: (context, snapshot) {
                          scannedBarcodes = snapshot.data?.barcodes ?? [];

                          if (scannedBarcodes.isEmpty) {
                            isVisible = false;
                            return const Text(
                              'Scan something!',
                              overflow: TextOverflow.fade,
                              style: TextStyle(color: Colors.white),
                            );
                          }

                          Map<String, dynamic> json = jsonDecode(
                              scannedBarcodes.first.displayValue.toString());
                          print(scannedBarcodes.first.displayValue);
                          tid = json["TID"];
                          date = json["Date"];
                          time = json["Time"];
                          isVisible = true;
                          // setState(() {});

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                tid ?? "",
                                overflow: TextOverflow.fade,
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                              5.vSpacer,
                              AppFilledButton(
                                onPressed: () async {
                                  await getSingleTerminal(
                                      ref: ref, terminalId: tid ?? "");
                                  final err = ref.watch(terminalErrorProv);
                                  if (err != null) {
                                    AppUtil.showSnackBar(context,
                                        text: err, error: true);
                                  } else {
                                    final terminal = ref.watch(fetchedTerminal);
                                    if (terminal == null) {
                                      return;
                                    }
                                    ref.read(scanDateTimeProv.notifier).state =
                                        ScanDateTime(
                                            scanDate: date ?? "",
                                            scanTime: time ?? "");

                                    context.pushNamed(
                                      LogSupportPage.routeName,
                                      extra: TerminalParams(
                                          terminalModel: terminal,
                                          taskId: null),
                                    );
                                  }
                                },
                                text: "Select TID",
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, value, child) {
                if (!value.isInitialized ||
                    !value.isRunning ||
                    value.error != null) {
                  return const SizedBox();
                }
                return CustomPaint(
                  painter: ScannerOverlay(scanWindow: scanWindow),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 12.0,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    // we need to pass the size to the custom paint widget
    final backgroundPath = Path()..addRect(Rect.largest);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // First, draw the background,
    // with a cutout area that is a bit larger than the scan window.
    // Finally, draw the scan window itself.
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}

class ScannedBarcodeLabel extends StatelessWidget {
  const ScannedBarcodeLabel({
    super.key,
    required this.barcodes,
  });

  final Stream<BarcodeCapture> barcodes;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: barcodes,
      builder: (context, snapshot) {
        final scannedBarcodes = snapshot.data?.barcodes ?? [];

        if (scannedBarcodes.isNotEmpty) {
          context
              .pop(scannedBarcodes.first.displayValue ?? 'No display value.');
        }

        if (scannedBarcodes.isEmpty) {
          return const Text(
            'Scan something!',
            overflow: TextOverflow.fade,
            style: TextStyle(color: Colors.white),
          );
        }

        return Text(
          scannedBarcodes.first.displayValue ?? 'No display value.',
          overflow: TextOverflow.fade,
          style: const TextStyle(color: Colors.white),
        );
      },
    );
  }
}

class ToggleFlashlightButton extends StatelessWidget {
  const ToggleFlashlightButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        switch (state.torchState) {
          case TorchState.auto:
            return IconButton(
              color: AppColors.unselectedGrey,
              iconSize: 24.0,
              icon: const Icon(Icons.flash_auto),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.off:
            return IconButton(
              color: AppColors.unselectedGrey,
              iconSize: 24.0,
              icon: const Icon(Icons.flash_off),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.on:
            return IconButton(
              color: AppColors.unselectedGrey,
              iconSize: 24.0,
              icon: const Icon(Icons.flash_on),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.unavailable:
            return const Icon(
              Icons.no_flash,
              color: Colors.grey,
            );
        }
      },
    );
  }
}

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'Scanning is unsupported on this device';
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
