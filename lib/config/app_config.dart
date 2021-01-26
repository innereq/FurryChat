abstract class AppConfig {
  static String get applicationName => _applicationName;
  static String _applicationName = 'FurryChat';
  static String get defaultHomeserver => _defaultHomeserver;
  static String _defaultHomeserver = 'matrix.tchncs.de';
  static String get privacyUrl => _privacyUrl;
  static String _privacyUrl = 'https://fluffychat.im/en/privacy.html';
  static String get sourceCodeUrl => _sourceCodeUrl;
  static String _sourceCodeUrl = 'https://github.com/innereq/FurryChat';
  static String get supportUrl => _supportUrl;
  static String _supportUrl = 'https://github.com/innereq/FurryChat/issues';
  static bool renderHtml = false;
  static bool hideRedactedEvents = false;
  static bool hideUnknownEvents = false;
  static String matrixToLinkPrefix = 'https://matrix.to/#/';

  static void loadFromJson(Map<String, dynamic> json) {
    if (json['application_name'] is String) {
      _applicationName = json['application_name'];
    }
    if (json['default_homeserver'] is String) {
      _defaultHomeserver = json['default_homeserver'];
    }
    if (json['privacy_url'] is String) {
      _privacyUrl = json['privacy_url'];
    }
    if (json['source_code_url'] is String) {
      _sourceCodeUrl = json['source_code_url'];
    }
    if (json['support_url'] is String) {
      _supportUrl = json['support_url'];
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
