import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:picswap/app/manager/constants.dart';
import 'package:share_plus/share_plus.dart';

class DynamicLinkManager {
  static void sendProductDynamicLink(
      String id, String? name, String? description, String? imageUrl) async {
    _sendDynamicLinkUri(
      Uri.parse('${AppConstants.dynamicLinkPrefix}/$id'),
      name,
      description,
      imageUrl,
    );
  }

  static void _sendDynamicLinkUri(
      Uri linkUri, String? title, String? description, String? imageUrl) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: AppConstants.dynamicLinkPrefix,
      link: linkUri,
      androidParameters: const AndroidParameters(
        packageName: AppConstants.androidAppId,
      ),
      iosParameters: const IOSParameters(
        bundleId: AppConstants.iosAppId,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: title,
        description: description,
        imageUrl: imageUrl != null ? Uri.parse(imageUrl) : null,
      ),
    );
    final ShortDynamicLink shortDynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    await Share.share(shortDynamicLink.shortUrl.toString(),
        subject: '$title\n$description');
  }
}
