import 'package:coffee2u/controller/frontend_controller.dart';
import 'package:coffee2u/screens/partner/product/components/youtube_full_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeView extends StatefulWidget {
  const YoutubeView({
    super.key,
    required this.youtubeId,
    required this.backTo,
  });
  final String youtubeId;
  final String backTo;

  @override
  State<YoutubeView> createState() => _YoutubeViewState();
}

class _YoutubeViewState extends State<YoutubeView> {
  late Duration? duration2 = Get.find<FrontendController>().youtubeDuration;
  late YoutubePlayerController controllerWidget;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState dataPlayerState;
  late YoutubeMetaData dataVideoMetaData;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    controllerWidget = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      flags:  YoutubePlayerFlags(
        mute: false,
        autoPlay: duration2 != null,
        startAt: duration2 != null ? duration2!.inSeconds : 0,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    dataVideoMetaData = const YoutubeMetaData();
    dataPlayerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !controllerWidget.value.isFullScreen) {
      setState(() {
        dataPlayerState = controllerWidget.value.playerState;
        dataVideoMetaData = controllerWidget.metadata;
      });
    }
  }

  @override
  void deactivate() {
    controllerWidget.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    Get.find<FrontendController>().updateYoutubeDuration(null, needUpdate: false);
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      },
      onEnterFullScreen: () async {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        Get.to(() => YoutubeFullScreen(
          youtubeId: widget.youtubeId,
          duration: controllerWidget.value.position,
          backTo: widget.backTo,
        ));
      },
      player: YoutubePlayer(
        controller: controllerWidget,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        onReady: () {
          setState(() => _isPlayerReady = true);
        },
        onEnded: (data) {},
      ),
      builder: (context, player) => Column(
        children: [
          player,
        ],
      )
    );
  }
}