import 'package:bot_toast/bot_toast.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/adaptive_page_layout.dart';
import '../../components/avatar.dart';
import '../../components/dialogs/simple_dialogs.dart';
import '../../components/matrix.dart';
import '../../utils/app_route.dart';
import '../../utils/platform_infos.dart';
import '../settings.dart';
import 'settings_ignore_list.dart';

class AccountSettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: Settings(currentSetting: SettingsViews.account),
      secondScaffold: AccountSettings(),
    );
  }
}

class AccountSettings extends StatefulWidget {
  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  Future<dynamic> profileFuture;
  dynamic profile;

  void logoutAction(BuildContext context) async {
    if (await SimpleDialogs(context).askConfirmation() == false) {
      return;
    }
    var matrix = Matrix.of(context);
    await SimpleDialogs(context)
        .tryRequestWithLoadingDialog(matrix.client.logout());
  }

  void _changePasswordAccountAction(BuildContext context) async {
    final oldPassword = await SimpleDialogs(context).enterText(
      password: true,
      titleText: L10n.of(context).pleaseEnterYourPassword,
    );
    if (oldPassword == null) return;
    final newPassword = await SimpleDialogs(context).enterText(
      password: true,
      titleText: L10n.of(context).chooseAStrongPassword,
    );
    if (newPassword == null) return;
    await SimpleDialogs(context).tryRequestWithLoadingDialog(
      Matrix.of(context)
          .client
          .changePassword(newPassword, oldPassword: oldPassword),
    );
    BotToast.showText(text: L10n.of(context).passwordHasBeenChanged);
  }

  void _deleteAccountAction(BuildContext context) async {
    if (await SimpleDialogs(context).askConfirmation(
          titleText: L10n.of(context).warning,
          contentText: L10n.of(context).deactivateAccountWarning,
          dangerous: true,
        ) ==
        false) {
      return;
    }
    if (await SimpleDialogs(context).askConfirmation(dangerous: true) ==
        false) {
      return;
    }
    final password = await SimpleDialogs(context).enterText(
      password: true,
      titleText: L10n.of(context).pleaseEnterYourPassword,
    );
    if (password == null) return;
    await SimpleDialogs(context).tryRequestWithLoadingDialog(
      Matrix.of(context).client.deactivateAccount(auth: {
        'type': 'm.login.password',
        'user': Matrix.of(context).client.userID,
        'password': password,
      }),
    );
  }

  void setJitsiInstanceAction(BuildContext context) async {
    var jitsi = await SimpleDialogs(context).enterText(
      titleText: L10n.of(context).editJitsiInstance,
      hintText: Matrix.of(context).jitsiInstance,
      labelText: L10n.of(context).editJitsiInstance,
    );
    if (jitsi == null) return;
    if (!jitsi.endsWith('/')) {
      jitsi += '/';
    }
    final matrix = Matrix.of(context);
    await matrix.store.setItem('chat.fluffy.jitsi_instance', jitsi);
    matrix.jitsiInstance = jitsi;
  }

  void setDisplaynameAction(BuildContext context) async {
    final displayname = await SimpleDialogs(context).enterText(
      titleText: L10n.of(context).editDisplayname,
      hintText:
          profile?.displayname ?? Matrix.of(context).client.userID.localpart,
      labelText: L10n.of(context).enterAUsername,
    );
    if (displayname == null) return;
    final matrix = Matrix.of(context);
    final success = await SimpleDialogs(context).tryRequestWithLoadingDialog(
      matrix.client.setDisplayname(matrix.client.userID, displayname),
    );
    if (success != false) {
      setState(() {
        profileFuture = null;
        profile = null;
      });
    }
  }

  void setAvatarAction(BuildContext context) async {
    MatrixFile file;
    if (PlatformInfos.isMobile) {
      final result = await ImagePicker().getImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          maxWidth: 1600,
          maxHeight: 1600);
      if (result == null) return;
      file = MatrixFile(
        bytes: await result.readAsBytes(),
        name: result.path,
      );
    } else {
      final result =
          await FilePickerCross.importFromStorage(type: FileTypeCross.image);
      if (result == null) return;
      file = MatrixFile(
        bytes: result.toUint8List(),
        name: result.fileName,
      );
    }
    final matrix = Matrix.of(context);
    final success = await SimpleDialogs(context).tryRequestWithLoadingDialog(
      matrix.client.setAvatar(file),
    );
    if (success != false) {
      setState(() {
        profileFuture = null;
        profile = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    profileFuture ??= client.ownProfile.then((p) {
      if (mounted) setState(() => profile = p);
      return p;
    });
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).account)),
      body: ListView(
        children: [
          ListTile(
            leading: Avatar(
              profile?.avatarUrl,
              profile?.displayname ?? client.userID.toString(),
              size: 24.0,
            ),
            title: Text(L10n.of(context).avatar),
            onTap: () => setAvatarAction(context),
          ),
          ListTile(
            leading: Icon(Icons.edit_outlined),
            title: Text(L10n.of(context).editDisplayname),
            subtitle: Text(profile?.displayname ?? client.userID.localpart),
            onTap: () => setDisplaynameAction(context),
          ),
          ListTile(
            leading: Icon(Icons.phone_outlined),
            title: Text(L10n.of(context).editJitsiInstance),
            subtitle: Text(Matrix.of(context).jitsiInstance),
            onTap: () => setJitsiInstanceAction(context),
          ),
          ListTile(
            leading: Icon(Icons.block_outlined),
            title: Text(L10n.of(context).ignoredUsers),
            onTap: () async => await Navigator.of(context).push(
              AppRoute.defaultRoute(
                context,
                SettingsIgnoreListView(),
              ),
            ),
          ),
          Divider(thickness: 1),
          ListTile(
            leading: Icon(Icons.vpn_key_outlined),
            title: Text(L10n.of(context).changeThePassword),
            onTap: () => _changePasswordAccountAction(context),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app_outlined),
            title: Text(L10n.of(context).logout),
            onTap: () => logoutAction(context),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever_outlined),
            title: Text(
              L10n.of(context).deleteAccount,
              style: TextStyle(color: Colors.red),
            ),
            onTap: () => _deleteAccountAction(context),
          ),
        ],
      ),
    );
  }
}
