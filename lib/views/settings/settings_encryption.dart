import 'package:furrychat/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:furrychat/utils/beautify_string_extension.dart';

import 'package:furrychat/components/dialogs/simple_dialogs.dart';
import 'package:furrychat/components/adaptive_page_layout.dart';
import 'package:furrychat/components/matrix.dart';
import 'package:olm/olm.dart' as olm;

class EncryptionSettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: Settings(currentSetting: SettingsViews.encryption),
      secondScaffold: EncryptionSettings(),
    );
  }
}

class EncryptionSettings extends StatefulWidget {
  @override
  _EncryptionSettingsState createState() => _EncryptionSettingsState();
}

class _EncryptionSettingsState extends State<EncryptionSettings> {
  Future<dynamic> profileFuture;
  dynamic profile;
  Future<bool> crossSigningCachedFuture;
  bool crossSigningCached;
  Future<bool> megolmBackupCachedFuture;
  bool megolmBackupCached;

  Future<void> requestSSSSCache(BuildContext context) async {
    final handle = Matrix.of(context).client.encryption.ssss.open();
    final str = await SimpleDialogs(context).enterText(
      titleText: L10n.of(context).askSSSSCache,
      hintText: L10n.of(context).passphraseOrKey,
      password: true,
    );
    if (str != null) {
      SimpleDialogs(context).showLoadingDialog(context);
      // make sure the loading spinner shows before we test the keys
      await Future.delayed(Duration(milliseconds: 100));
      var valid = false;
      try {
        handle.unlock(recoveryKey: str);
        valid = true;
      } catch (e, s) {
        debugPrint('Couldn\'t use recovery key: ' + e.toString());
        debugPrint(s.toString());
        try {
          handle.unlock(passphrase: str);
          valid = true;
        } catch (e, s) {
          debugPrint('Couldn\'t use recovery passphrase: ' + e.toString());
          debugPrint(s.toString());
          valid = false;
        }
      }
      await Navigator.of(context)?.pop();
      if (valid) {
        await handle.maybeCacheAll();
        await SimpleDialogs(context).inform(
          contentText: L10n.of(context).cachedKeys,
        );
        setState(() {
          crossSigningCachedFuture = null;
          crossSigningCached = null;
          megolmBackupCachedFuture = null;
          megolmBackupCached = null;
        });
      } else {
        await SimpleDialogs(context).inform(
          contentText: L10n.of(context).incorrectPassphraseOrKey,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    profileFuture ??= client.ownProfile.then((p) {
      if (mounted) setState(() => profile = p);
      return p;
    });
    crossSigningCachedFuture ??=
        client.encryption.crossSigning.isCached().then((c) {
      if (mounted) setState(() => crossSigningCached = c);
      return c;
    });
    megolmBackupCachedFuture ??=
        client.encryption.keyManager.isCached().then((c) {
      if (mounted) setState(() => megolmBackupCached = c);
      return c;
    });

    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).encryption)),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.compare_arrows_outlined),
            title: Text(client.encryption.crossSigning.enabled
                ? L10n.of(context).crossSigningEnabled
                : L10n.of(context).crossSigningDisabled),
            subtitle: client.encryption.crossSigning.enabled
                ? Text(client.isUnknownSession
                    ? L10n.of(context).unknownSessionVerify
                    : L10n.of(context).sessionVerified +
                        ', ' +
                        (crossSigningCached == null
                            ? '⌛'
                            : (crossSigningCached
                                ? L10n.of(context).keysCached
                                : L10n.of(context).keysMissing)))
                : null,
            onTap: () async {
              if (!client.encryption.crossSigning.enabled) {
                await SimpleDialogs(context).inform(
                  contentText: L10n.of(context).noCrossSignBootstrap,
                );
                return;
              }
              if (client.isUnknownSession) {
                final str = await SimpleDialogs(context).enterText(
                  titleText: L10n.of(context).askSSSSVerify,
                  hintText: L10n.of(context).passphraseOrKey,
                  password: true,
                );
                if (str != null) {
                  SimpleDialogs(context).showLoadingDialog(context);
                  // make sure the loading spinner shows before we test the keys
                  await Future.delayed(Duration(milliseconds: 100));
                  var valid = false;
                  try {
                    await client.encryption.crossSigning
                        .selfSign(recoveryKey: str);
                    valid = true;
                  } catch (_) {
                    try {
                      await client.encryption.crossSigning
                          .selfSign(passphrase: str);
                      valid = true;
                    } catch (_) {
                      valid = false;
                    }
                  }
                  await Navigator.of(context)?.pop();
                  if (valid) {
                    await SimpleDialogs(context).inform(
                      contentText: L10n.of(context).verifiedSession,
                    );
                    setState(() {
                      crossSigningCachedFuture = null;
                      crossSigningCached = null;
                      megolmBackupCachedFuture = null;
                      megolmBackupCached = null;
                    });
                  } else {
                    await SimpleDialogs(context).inform(
                      contentText: L10n.of(context).incorrectPassphraseOrKey,
                    );
                  }
                }
              }
              if (!(await client.encryption.crossSigning.isCached())) {
                await requestSSSSCache(context);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.wb_cloudy_outlined),
            title: Text(client.encryption.keyManager.enabled
                ? L10n.of(context).onlineKeyBackupEnabled
                : L10n.of(context).onlineKeyBackupDisabled),
            subtitle: client.encryption.keyManager.enabled
                ? Text(megolmBackupCached == null
                    ? '⌛'
                    : (megolmBackupCached
                        ? L10n.of(context).keysCached
                        : L10n.of(context).keysMissing))
                : null,
            onTap: () async {
              if (!client.encryption.keyManager.enabled) {
                await SimpleDialogs(context).inform(
                  contentText: L10n.of(context).noMegolmBootstrap,
                );
                return;
              }
              if (!(await client.encryption.keyManager.isCached())) {
                await requestSSSSCache(context);
              }
            },
          ),
          Divider(thickness: 1),
          ListTile(
            title: Text('Device name:'),
            subtitle: Text(client.userDeviceKeys[client.userID]
                    ?.deviceKeys[client.deviceID]?.deviceDisplayName ??
                L10n.of(context).unknownDevice),
          ),
          ListTile(
            title: Text('Device ID:'),
            subtitle: Text(client.deviceID),
          ),
          ListTile(
            title: Text('Encryption enabled:'),
            subtitle: Text(client.encryptionEnabled.toString()),
          ),
          if (client.encryptionEnabled)
            Column(
              children: <Widget>[
                ListTile(
                  title: Text('Your public fingerprint key:'),
                  subtitle: Text(client.fingerprintKey.beautified),
                ),
                ListTile(
                  title: Text('Your public identity key:'),
                  subtitle: Text(client.identityKey.beautified),
                ),
                ListTile(
                  title: Text('LibOlm version:'),
                  subtitle: Text(olm.get_library_version().join('.')),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
