// lib/screens/cctv_view_screen.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CCTVViewScreen extends StatefulWidget {
  final String cctvUrl;
  final String roomName;

  const CCTVViewScreen({
    super.key,
    required this.cctvUrl,
    required this.roomName,
  });

  @override
  _CCTVViewScreenState createState() => _CCTVViewScreenState();
}

class _CCTVViewScreenState extends State<CCTVViewScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    // URL video dummy. Ganti dengan URL RTSP atau HLS sesungguhnya.
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.cctvUrl));

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // Memulai video secara otomatis dan mengulanginya
      _controller.play();
      _controller.setLooping(true);
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Pastikan untuk membuang controller untuk melepaskan resource
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CCTV - ${widget.roomName}'),
        backgroundColor: Colors.black, // Tema gelap untuk layar CCTV
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  _buildControlsOverlay(),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(
                'Gagal memuat video: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _buildControlsOverlay() {
    return Container(
      color: Colors.black26,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled,
              color: Colors.white,
              size: 50.0,
            ),
          ),
        ],
      ),
    );
  }
}
