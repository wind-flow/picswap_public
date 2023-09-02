// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:picswap/app/utils/extension/string_extensions.dart';

import '../../app/manager/colors_manager.dart';

class ImageBox extends ConsumerStatefulWidget {
  final Function()? onTap;
  final String url;
  final Widget? customWidget;
  final String roomId;
  const ImageBox({
    super.key,
    this.onTap,
    required this.url,
    this.customWidget,
    required this.roomId,
  });

  @override
  ConsumerState<ImageBox> createState() => _EmptyImageState();
}

class _EmptyImageState extends ConsumerState<ImageBox> {
  ImageProvider? imageProvider;

  @override
  void initState() {
    if (!widget.url.isNullOrEmpty()) {
      if (widget.url.isNetworkImage()) {
        imageProvider = NetworkImage(widget.url);
      } else {
        imageProvider = AssetImage(widget.url);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
            height: size * 0.35,
            width: size,
            decoration: BoxDecoration(
              color: AppColor.grey5Color,
              border: Border.all(color: AppColor.INPUT_BG_COLOR),
            ),
            child: ClipRRect(
              child: widget.url.isNullOrEmpty()
                  ? widget.customWidget
                  : ClipRRect(
                      child: Image(
                        image: imageProvider ?? NetworkImage(widget.url),
                        fit: BoxFit.contain,
                      ),
                    ),
            )),
        // child: ClipRRect(
        //     child: ref
        //         .watch(uploadPictureFutureProvider(widget.roomId))
        //         .when(data: (data) {
        //   return widget.url.isNullOrEmpty()
        //       ? widget.customWidget
        //       : ClipRRect(
        //           // borderRadius: BorderRadius.circular(AppSize.s16),
        //           child: Image(
        //             image: imageProvider ?? NetworkImage(widget.url),
        //             fit: BoxFit.fill,
        //           ),
        //         );
        // }, error: (error, stackTrace) {
        //   return Text(error.toString());
        // }, loading: () {
        //   return const Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }))),
      ),
    );
  }
}
