import 'media_item.dart';
import 'media_user_state.dart';

class MediaEntry {
  const MediaEntry({required this.item, required this.userState});

  final MediaItem item;
  final MediaUserState? userState;

  bool get hasResume =>
      (userState?.lastPositionMs ?? 0) > 0 &&
      (userState?.isFinished ?? false) == false;
}
