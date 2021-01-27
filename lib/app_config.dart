import 'dart:ui';

abstract class AppConfig {
  static String _applicationName = 'FurryChat';
  static String get applicationName => _applicationName;
  static String _applicationWelcomeMessage;
  static String get applicationWelcomeMessage => _applicationWelcomeMessage;
  static String _defaultHomeserver = 'matrix.org';
  static String get defaultHomeserver => _defaultHomeserver;
  static String jitsiInstance = 'https://meet.jit.si/';
  static const bool allowOtherHomeservers = true;
  static const bool enableRegistration = true;
  static const Color primaryColor = Color(0xFF5625BA);
  static const Color primaryColorLight = Color(0xFFF5B4D2);
  static String _privacyUrl = 'https://fluffychat.im/en/privacy.html';
  static String get privacyUrl => _privacyUrl;
  static const String sourceCodeUrl = 'https://github.com/innereq/FurryChat';
  static const String appId = 'dev.inex.furrychat';
  static const String supportUrl =
      'https://github.com/innereq/FurryChat/issues';
  static bool renderHtml = false;
  static bool hideRedactedEvents = false;
  static bool hideUnknownEvents = false;
  static const bool hideTypingUsernames = false;
  static const bool hideAllStateEvents = false;
  static const String inviteLinkPrefix = 'https://matrix.to/#/';
  static const String pushNotificationsChannelId = 'furrychat_push';
  static const String pushNotificationsChannelName = 'FurryChat push channel';
  static const String schemePrefix = 'matrix:';
  static const String pushNotificationsChannelDescription =
      'Push notifications for FurryChat';
  static const String pushNotificationsAppId = 'dev.inex.furrychat';
  static const String pushNotificationsGatewayUrl =
      'https://push-gateway.inex.dev:443/_matrix/push/v1/notify';
  static const String pushNotificationsPusherFormat = 'event_id_only';
  static const String emojiFontName = 'Noto Emoji';
  static const String emojiFontUrl =
      'https://github.com/googlefonts/noto-emoji/';

  static void loadFromJson(Map<String, dynamic> json) {
    if (json['application_name'] is String) {
      _applicationName = json['application_name'];
    }
    if (json['application_welcome_message'] is String) {
      _applicationWelcomeMessage = json['application_welcome_message'];
    }
    if (json['default_homeserver'] is String) {
      _defaultHomeserver = json['default_homeserver'];
    }
    if (json['jitsi_instance'] is String) {
      jitsiInstance = json['jitsi_instance'];
    }
    if (json['privacy_url'] is String) {
      _privacyUrl = json['privacy_url'];
    }
    if (json['render_html'] is bool) {
      renderHtml = json['render_html'];
    }
    if (json['hide_redacted_events'] is bool) {
      hideRedactedEvents = json['hide_redacted_events'];
    }
    if (json['hide_unknown_events'] is bool) {
      hideUnknownEvents = json['hide_unknown_events'];
    }
  }
}