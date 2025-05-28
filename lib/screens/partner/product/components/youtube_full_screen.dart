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
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
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
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    _controller.toggleFullScreenMode();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
     return YoutubePlayerBuilder(
      onExitFullScreen: () {
        frontendController.updateYoutubeDuration(_controller.value.position);
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,]);
        Get.until((route) => Get.currentRoute == widget.backTo);
      },
      player: YoutubePlayer(
        controller: _controller,
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
