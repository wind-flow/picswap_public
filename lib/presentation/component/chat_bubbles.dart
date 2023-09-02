import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

import '../../app/manager/colors_manager.dart';
import '../../app/manager/values_manager.dart';

class ChatBubbles extends StatelessWidget {
  const ChatBubbles({
    super.key,
    required this.message,
    required this.isMe,
    required this.nickname,
  });
  final String nickname;
  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: EdgeInsets.fromLTRB(isMe ? 0 : 36, 0, isMe ? 36 : 0, 0),
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Column(
              children: [
                // Text(nickname),
                Padding(
                  padding: EdgeInsets.fromLTRB(isMe ? 10 : AppPadding.p24, 10,
                      isMe ? AppPadding.p24 : 10, 0),
                  child: ChatBubble(
                    clipper: ChatBubbleClipper8(
                        type: isMe
                            ? BubbleType.sendBubble
                            : BubbleType.receiverBubble),
                    alignment: isMe ? Alignment.topRight : null,
                    margin: const EdgeInsets.only(
                        top: AppMargin.m12, bottom: AppMargin.m12),
                    backGroundColor:
                        isMe ? AppColor.primaryColor : const Color(0xffE7E7ED),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            nickname,
                            style: TextStyle(
                                color: isMe
                                    ? AppColor.white1Color
                                    : AppColor.black1Color),
                          ),
                          Text(
                            message,
                            style: TextStyle(
                                color: isMe
                                    ? AppColor.white1Color
                                    : AppColor.black1Color),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ]);
  }
}
