import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/widgets/conditional.widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoContent extends StatefulWidget {
  const VideoContent({
    Key? key,
    required this.constraints,
    required this.url,
  }) : super(key: key);

  final BoxConstraints constraints;
  final String url;

  @override
  _VideoContentState createState() => _VideoContentState();
}

class _VideoContentState extends State<VideoContent> {
  late VideoPlayerController _controller;

  final ComponentController component = Get.find();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalWidget(
      condition: _controller.value.isInitialized,
      trueWidget: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: widget.constraints.maxHeight - 115,
            child: Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                    )
                  ],
                ),
                Container(
                  child: VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: Color(component.accentColor.value),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      falseWidget: LoadingIndicator(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
