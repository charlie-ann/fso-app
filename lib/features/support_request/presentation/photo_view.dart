import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/reusables/loader_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewPage extends StatefulWidget {
  static const String routeName = 'photo-view-page';
  const PhotoViewPage({
    super.key,
    required this.url,
  });

  final String? url;

  @override
  State<PhotoViewPage> createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  File? pdfFile;
  bool isLoading = false;

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    if (widget.url?.contains("pdf") ?? false) {
      createFileOfPdfUrl().then((value) {
        setState(() {
          pdfFile = value;
        });
      });
    }
    // });

    super.initState();
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    debugPrint("Start download file from internet!");
    setState(() {
      isLoading = true;
    });
    try {
      final url = widget.url ?? "";
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      debugPrint("Download files");
      debugPrint("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Error parsing asset file!');
    }
    setState(() {
      isLoading = false;
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return LoaderView(
      loading: isLoading,
      isOverlay: false,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              constraints: BoxConstraints.expand(
                height: MediaQuery.of(context).size.height,
              ),
              child: (widget.url?.contains("pdf") ?? false)
                  ? isLoading
                      ? const SizedBox()
                      : PDFScreen(
                          path: pdfFile?.path,
                        )
                  : PhotoView(
                      imageProvider: NetworkImage(widget.url ?? ""),
                      // backgroundDecoration: backgroundDecoration,
                      // minScale: minScale,
                      // maxScale: maxScale,
                      heroAttributes:
                          const PhotoViewHeroAttributes(tag: "someTag"),
                    ),
            ),
            Positioned(
              top: 80,
              left: 10,
              height: 34,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                      color: AppColors.backgroundColor.withOpacity(.85),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary)),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PDFScreen extends StatefulWidget {
  final String? path;

  const PDFScreen({super.key, this.path});

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
                false, // if set to true the link is handled in flutter
            backgroundColor: Colors.black,
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              debugPrint(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              debugPrint('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              debugPrint('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              debugPrint('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
    );
  }
}
