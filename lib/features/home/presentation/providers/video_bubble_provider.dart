import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoBubbleState {
  final bool isVisible;
  final String? videoUrl;

  VideoBubbleState({this.isVisible = false, this.videoUrl});
}

class VideoBubbleNotifier extends Notifier<VideoBubbleState> {
  @override
  VideoBubbleState build() {
    return VideoBubbleState();
  }

  void showBubble(String url) {
    state = VideoBubbleState(isVisible: true, videoUrl: url);
  }

  void hideBubble() {
    state = VideoBubbleState(isVisible: false, videoUrl: null);
  }
}

final videoBubbleProvider =
    NotifierProvider<VideoBubbleNotifier, VideoBubbleState>(
      VideoBubbleNotifier.new,
    );
