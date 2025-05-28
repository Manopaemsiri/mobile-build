import 'package:coffee2u/controller/frontend_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeFullScreen extends StatefulWidget {
  const YoutubeFullScreen({ 
    super.key , 
    required this.youtubeId,
    required this.duration,
    required this.backTo
  });
  final String youtubeId;
  final Duration duration;
  final String backTo;

  @override
  State<YoutubeFullScreen> createState() => _YoutubeFullScreenState();
}

class _YoutubeFullScreenState extends State<YoutubeFullScreen> {
  late FrontendController frontendController = Get.find<FrontendController>();
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
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        startAt: widget.duration.inSeconds,
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
    controllerWidget.toggleFullScreenMode();
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
    controllerWidget.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
     return YoutubePlayerBuilder(
      onExitFullScreen: () {
        frontendController.updateYoutubeDuration(controllerWidget.value.position);
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,]);
        Get.until((route) => Get.currentRoute == widget.backTo);
      },
      player: YoutubePlayer(
        controller: controllerWidget,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        onReady: () => setState(() => _isPlayerReady = true),
      ),
      builder: (context, player) => Column(
        children: [
          player,
        ],
      ),
    );
  }
}
