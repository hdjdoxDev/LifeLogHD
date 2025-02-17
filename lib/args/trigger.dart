import 'package:url_launcher/url_launcher.dart';

class TriggerListener {
  Map<String, bool Function()> triggerCallbacks = {};

  bool urlCallback(url) {
    launchUrl(url);
    return true;
  }
}
