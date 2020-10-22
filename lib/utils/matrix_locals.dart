import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

/// This is a temporary helper class until there is a proper solution to this with the new system
class MatrixLocals extends MatrixLocalizations {
  final L10n l10n;

  MatrixLocals(this.l10n);

  @override
  String acceptedTheInvitation(String targetName) =>
      l10n.acceptedTheInvitation(targetName);

  @override
  String activatedEndToEndEncryption(String senderName) =>
      l10n.activatedEndToEndEncryption(senderName);

  @override
  String answeredTheCall(String senderName) => l10n.answeredTheCall(senderName);

  @override
  String get anyoneCanJoin => l10n.anyoneCanJoin;

  @override
  String bannedUser(String senderName, String targetName) =>
      l10n.bannedUser(senderName, targetName);

  @override
  String changedTheChatAvatar(String senderName) =>
      l10n.changedTheChatAvatar(senderName);

  @override
  String changedTheChatDescriptionTo(String senderName, String content) =>
      l10n.changedTheChatDescriptionTo(senderName, content);

  @override
  String changedTheChatNameTo(String senderName, String content) =>
      l10n.changedTheChatNameTo(senderName, content);

  @override
  String changedTheChatPermissions(String senderName) =>
      l10n.changedTheChatPermissions(senderName);

  @override
  String changedTheDisplaynameTo(String targetName, String newDisplayname) =>
      l10n.changedTheDisplaynameTo(targetName, newDisplayname);

  @override
  String changedTheGuestAccessRules(String senderName) =>
      l10n.changedTheGuestAccessRules(senderName);

  @override
  String changedTheGuestAccessRulesTo(
          String senderName, String localizedString) =>
      l10n.changedTheGuestAccessRulesTo(senderName, localizedString);

  @override
  String changedTheHistoryVisibility(String senderName) =>
      l10n.changedTheHistoryVisibility(senderName);

  @override
  String changedTheHistoryVisibilityTo(
          String senderName, String localizedString) =>
      l10n.changedTheHistoryVisibilityTo(senderName, localizedString);

  @override
  String changedTheJoinRules(String senderName) =>
      l10n.changedTheJoinRules(senderName);

  @override
  String changedTheJoinRulesTo(String senderName, String localizedString) =>
      l10n.changedTheJoinRulesTo(senderName, localizedString);

  @override
  String changedTheProfileAvatar(String targetName) =>
      l10n.changedTheProfileAvatar(targetName);

  @override
  String changedTheRoomAliases(String senderName) =>
      l10n.changedTheRoomAliases(senderName);

  @override
  String changedTheRoomInvitationLink(String senderName) =>
      l10n.changedTheRoomInvitationLink(senderName);

  @override
  String get channelCorruptedDecryptError => l10n.channelCorruptedDecryptError;

  @override
  String couldNotDecryptMessage(String errorText) =>
      l10n.couldNotDecryptMessage(errorText);

  @override
  String createdTheChat(String senderName) => l10n.createdTheChat(senderName);

  @override
  String get emptyChat => l10n.emptyChat;

  @override
  String get encryptionNotEnabled => l10n.encryptionNotEnabled;

  @override
  String endedTheCall(String senderName) => l10n.endedTheCall(senderName);

  @override
  String get fromJoining => l10n.fromJoining;

  @override
  String get fromTheInvitation => l10n.fromTheInvitation;

  @override
  String groupWith(String displayname) => l10n.groupWith(displayname);

  @override
  String get guestsAreForbidden => l10n.guestsAreForbidden;

  @override
  String get guestsCanJoin => l10n.guestsCanJoin;

  @override
  String hasWithdrawnTheInvitationFor(String senderName, String targetName) =>
      l10n.hasWithdrawnTheInvitationFor(senderName, targetName);

  @override
  String invitedUser(String senderName, String targetName) =>
      l10n.invitedUser(senderName, targetName);

  @override
  String get invitedUsersOnly => l10n.invitedUsersOnly;

  @override
  String joinedTheChat(String targetName) => l10n.joinedTheChat(targetName);

  @override
  String kicked(String senderName, String targetName) =>
      l10n.kicked(senderName, targetName);

  @override
  String kickedAndBanned(String senderName, String targetName) =>
      l10n.kickedAndBanned(senderName, targetName);

  @override
  String get needPantalaimonWarning => l10n.needPantalaimonWarning;

  @override
  String get noPermission => l10n.noPermission;

  @override
  String redactedAnEvent(String senderName) => l10n.redactedAnEvent(senderName);

  @override
  String rejectedTheInvitation(String targetName) =>
      l10n.rejectedTheInvitation(targetName);

  @override
  String removedBy(String calcDisplayname) => l10n.removedBy(calcDisplayname);

  @override
  String get roomHasBeenUpgraded => l10n.roomHasBeenUpgraded;

  @override
  String sentAFile(String senderName) => l10n.sentAFile(senderName);

  @override
  String sentAPicture(String senderName) => l10n.sentAPicture(senderName);

  @override
  String sentASticker(String senderName) => l10n.sentASticker(senderName);

  @override
  String sentAVideo(String senderName) => l10n.sentAVideo(senderName);

  @override
  String sentAnAudio(String senderName) => l10n.sentAnAudio(senderName);

  @override
  String sentCallInformations(String senderName) =>
      l10n.sentCallInformations(senderName);

  @override
  String sharedTheLocation(String senderName) =>
      l10n.sharedTheLocation(senderName);

  @override
  String startedACall(String senderName) => l10n.startedACall(senderName);

  @override
  String unbannedUser(String senderName, String targetName) =>
      l10n.unbannedUser(senderName, targetName);

  @override
  String get unknownEncryptionAlgorithm => l10n.unknownEncryptionAlgorithm;

  @override
  String unknownEvent(String typeKey) => l10n.unknownEvent(typeKey);

  @override
  String userLeftTheChat(String targetName) => l10n.userLeftTheChat(targetName);

  @override
  String get visibleForAllParticipants => l10n.visibleForAllParticipants;

  @override
  String get visibleForEveryone => l10n.visibleForEveryone;

  @override
  String get you => l10n.you;
}
