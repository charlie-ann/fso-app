import 'package:flutter/material.dart';
import 'package:fso_support/core/reusables/loader_view.dart';

class EPageWrapper extends StatefulWidget {
  final bool isLoading;
  final List<Widget> children;
  final bool shouldScroll;
  final Function? onBackPressed;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  const EPageWrapper({
    super.key,
    this.isLoading = false,
    required this.children,
    this.shouldScroll = true,
    this.bottomNavigationBar,
    this.appBar,
    this.onBackPressed,
  });

  @override
  State<EPageWrapper> createState() => _EPageWrapperState();
}

class _EPageWrapperState extends State<EPageWrapper> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: LoaderView(
        loading: widget.isLoading,
        child: Scaffold(
          appBar: widget.appBar,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            physics: !(widget.shouldScroll)
                ? const NeverScrollableScrollPhysics()
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.children,
            ),
          ),
          bottomNavigationBar: widget.bottomNavigationBar,
        ),
      ),
    );
  }
}
