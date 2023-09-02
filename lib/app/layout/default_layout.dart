// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../manager/colors_manager.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final AppBar? appBar;
  final String? title;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget? leading;
  final Drawer? drawer;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool? extendBody;
  final List<Widget>? action;
  final bool? extendBodyBehindAppBar;
  final Widget? endDrawer;

  const DefaultLayout(
      {Key? key,
      this.backgroundColor,
      required this.child,
      this.appBar,
      this.title,
      this.bottomNavigationBar,
      this.floatingActionButton,
      this.leading,
      this.action,
      this.drawer,
      this.floatingActionButtonLocation,
      this.extendBody = false,
      this.extendBodyBehindAppBar,
      this.endDrawer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
        extendBody: extendBody ?? false,
        backgroundColor: backgroundColor ?? Colors.white,
        appBar: title == null && appBar != null ? appBar : renderAppBar(),
        bottomNavigationBar: bottomNavigationBar,
        body: child,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        drawer: drawer,
        endDrawer: endDrawer,
      ),
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title!,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        foregroundColor: Colors.white,
        leading: leading,
        actions: action,
      );
    }
  }
}
