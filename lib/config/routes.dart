import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';

import '../components/matrix.dart';
import '../views/archive.dart';
import '../views/auth_web_view.dart';
import '../views/chat.dart';
import '../views/chat_details.dart';
import '../views/chat_encryption_settings.dart';
import '../views/chat_list.dart';
import '../views/chat_permissions_settings.dart';
import '../views/discover_view.dart';
import '../views/empty_page.dart';
import '../views/homeserver_picker.dart';
import '../views/invitation_selection.dart';
import '../views/loading_view.dart';
import '../views/log_view.dart';
import '../views/login.dart';
import '../views/new_group.dart';
import '../views/new_private_chat.dart';
import '../views/settings.dart';
import '../views/settings/settings_account.dart';
import '../views/settings/settings_chat.dart';
import '../views/settings/settings_devices.dart';
import '../views/settings/settings_emotes.dart';
import '../views/settings/settings_encryption.dart';
import '../views/settings/settings_homeserver.dart';
import '../views/settings/settings_ignore_list.dart';
import '../views/settings/settings_multiple_emotes.dart';
import '../views/settings/settings_notifications.dart';
import '../views/settings/settings_themes.dart';
import '../views/settings_3pid.dart';
import '../views/sign_up.dart';
import '../views/sign_up_password.dart';
import '../views/sso_web_view.dart';

class FluffyRoutes {
  final BuildContext context;

  const FluffyRoutes(this.context);

  ViewData onGenerateRoute(RouteSettings settings) {
    final parts = settings.name.split('/');

    // Routes if the app is loading
    if (Matrix.of(context).loginState == null) {
      return ViewData(mainView: (_) => LoadingView());
      // Routes if user is NOT logged in
    } else if (Matrix.of(context).loginState == LoginState.loggedOut) {
      switch (parts[1]) {
        case '':
          return ViewData(mainView: (_) => HomeserverPicker());
        case 'login':
          return ViewData(mainView: (_) => Login());
        case 'sso':
          return ViewData(mainView: (_) => SsoWebView());
        case 'signup':
          if (parts.length == 5 && parts[2] == 'password') {
            return ViewData(
              mainView: (_) => SignUpPassword(
                parts[3],
                displayname: parts[4],
                avatar: settings.arguments,
              ),
            );
          }
          return ViewData(mainView: (_) => SignUp());
        case 'authwebview':
          if (parts.length == 4) {
            return ViewData(
              mainView: (_) => AuthWebView(
                parts[2],
                Uri.decodeComponent(parts[3]),
                settings.arguments,
              ),
            );
          }
      }
    }
    // Routes IF user is logged in
    else {
      switch (parts[1]) {
        case '':
          return ViewData(
            mainView: (_) => ChatList(),
            emptyView: (_) => EmptyPage(),
          );
        case 'rooms':
          if (parts.length == 3) {
            return ViewData(
              leftView: (_) => ChatList(activeChat: parts[2]),
              mainView: (_) => Chat(parts[2]),
            );
          } else if (parts.length == 4) {
            final roomId = parts[2];
            final action = parts[3];
            switch (action) {
              case 'details':
                return ViewData(
                  leftView: (_) => ChatList(activeChat: parts[2]),
                  mainView: (_) => Chat(parts[2]),
                  rightView: (_) => ChatDetails(roomId),
                );
              case 'encryption':
                return ViewData(
                  leftView: (_) => ChatList(activeChat: parts[2]),
                  mainView: (_) => Chat(parts[2]),
                  rightView: (_) => ChatEncryptionSettings(roomId),
                );
              case 'permissions':
                return ViewData(
                  leftView: (_) => ChatList(activeChat: parts[2]),
                  mainView: (_) => Chat(parts[2]),
                  rightView: (_) => ChatPermissionsSettings(roomId),
                );
              case 'invite':
                return ViewData(
                  leftView: (_) => ChatList(activeChat: parts[2]),
                  mainView: (_) => Chat(parts[2]),
                  rightView: (_) => InvitationSelection(roomId),
                );
              case 'emotes':
                return ViewData(
                  leftView: (_) => ChatList(activeChat: parts[2]),
                  mainView: (_) => Chat(parts[2]),
                  rightView: (_) => MultipleEmotesSettings(roomId),
                );
            }
          }
          return ViewData(
            mainView: (_) => ChatList(),
            emptyView: (_) => EmptyPage(),
          );
        case 'archive':
          return ViewData(
            mainView: (_) => Archive(),
            emptyView: (_) => EmptyPage(),
          );
        case 'authwebview':
          if (parts.length == 4) {
            return ViewData(
              mainView: (_) => AuthWebView(
                parts[2],
                Uri.decodeComponent(parts[3]),
                settings.arguments,
              ),
            );
          }
          break;
        case 'discover':
          return ViewData(
            mainView: (_) =>
                DiscoverPage(alias: parts.length == 3 ? parts[2] : null),
            emptyView: (_) => EmptyPage(),
          );
        case 'logs':
          return ViewData(
            mainView: (_) => LogViewer(),
          );
        case 'newgroup':
          return ViewData(
            leftView: (_) => ChatList(),
            mainView: (_) => NewGroup(),
          );
        case 'newprivatechat':
          return ViewData(
            leftView: (_) => ChatList(),
            mainView: (_) => NewPrivateChat(),
          );
        case 'settings':
          if (parts.length == 3) {
            final action = parts[2];
            switch (action) {
              case '3pid':
                return ViewData(
                  leftView: (_) =>
                      Settings(currentSetting: SettingsViews.thridpid),
                  mainView: (_) => Settings3Pid(),
                );
              case 'account':
                return ViewData(
                  leftView: (_) =>
                      Settings(currentSetting: SettingsViews.account),
                  mainView: (_) => AccountSettings(),
                );
              case 'homeserver':
                return ViewData(
                  leftView: (_) =>
                      Settings(currentSetting: SettingsViews.homeserver),
                  mainView: (_) => HomeserverSettings(),
                );
              case 'chat':
                return ViewData(
                  leftView: (_) => Settings(currentSetting: SettingsViews.chat),
                  mainView: (_) => ChatSettings(),
                );
              case 'devices':
                return ViewData(
                  leftView: (_) =>
                      Settings(currentSetting: SettingsViews.devices),
                  mainView: (_) => DevicesSettings(),
                );
              case 'emotes':
                return ViewData(
                  leftView: (_) =>
                      Settings(currentSetting: SettingsViews.emotes),
                  mainView: (_) => EmotesSettings(room: settings.arguments),
                );
              case 'encryption':
                return ViewData(
                  leftView: (_) =>
                      Settings(currentSetting: SettingsViews.encryption),
                  mainView: (_) => EncryptionSettings(),
                );
              case 'ignore':
                return ViewData(
                  leftView: (_) =>
                      Settings(currentSetting: SettingsViews.account),
                  mainView: (_) => SettingsIgnoreList(),
                );
              case 'notifications':
                return ViewData(
                  leftView: (_) =>
                      Settings(currentSetting: SettingsViews.notifications),
                  mainView: (_) => SettingsNotifications(),
                );
              case 'style':
                return ViewData(
                  leftView: (_) =>
                      Settings(currentSetting: SettingsViews.style),
                  mainView: (_) => ThemesSettings(),
                );
            }
          }
          return ViewData(
            mainView: (_) => Settings(),
            emptyView: (_) => EmptyPage(),
          );
      }
    }

    // If route cant be found:
    return ViewData(
      mainView: (_) => Center(
        child: Text('Route "${settings.name}" not found...'),
      ),
    );
  }
}

class SettingsDevices {}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
