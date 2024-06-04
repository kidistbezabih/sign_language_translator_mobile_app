import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class Description extends StatefulWidget {
  static const String routeName = '/descrption';

  const Description({super.key});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  // VideoPlayerController? _videoPlayerController;
  var _isLoading = true;
  bool isVideoFinished = false;

  late VlcPlayerController _videoPlayerController;

  Future<void> initializePlayer() async {}

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final args = ModalRoute.of(context)!.settings.arguments
          as DescriptionScreenArguments;
      debugPrint(args.file.runtimeType.toString());

      final videoLink = await downloadVideoURL(videoFile: args.file.toString());

      _videoPlayerController = VlcPlayerController.network(
        // 'https://media.w3.org/2010/05/sintel/trailer.mp4',
        videoLink.toString(),
        hwAcc: HwAcc.full,
        autoPlay: true,
        autoInitialize: true,
        options: VlcPlayerOptions(),
      );


      _videoPlayerController.addListener(() {
        if (_videoPlayerController.value.position ==
            _videoPlayerController.value.duration) {
          setState(() {
            isVideoFinished = true;
          });
          _videoPlayerController
              .seekTo(Duration.zero); // Seek back to the beginning
        }
      });

      _isLoading = false;
      setState(() {});
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController.stopRendererScanning();
  }

  Future<String> downloadVideoURL({
    String videoFile = 'letters/a_family/a.mp4',
  }) async {
    try {
      String downloadURL =
          await FirebaseStorage.instance.ref(videoFile).getDownloadURL();
      // ignore: avoid_print
      print('THEEEE Download URL: $downloadURL');
      return downloadURL;
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text('Sign'),
          ],
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.blue[900],
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: 300,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                // child: Hero(
                //   tag: 'hero_picture',
                //   child: Image.asset(
                //     'assets/images/sign.png',
                //     width: 270,
                //     height: 300,
                //   ),
                // ),
                child: Hero(
                  tag: 'hero_picture',
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: 270,
                          child: VlcPlayer(
                            controller: _videoPlayerController,
                            aspectRatio: 16 / 9,
                            placeholder: const CircularProgressIndicator(color: Colors.black,),
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              isVideoFinished ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      // if (!((await _videoPlayerController.isPlaying()) ?? false)){
                      //   await _videoPlayerController.seekTo(Duration.zero);
                      // }

                      await _videoPlayerController.seekTo(Duration.zero);
                      debugPrint('${await _videoPlayerController.getPosition()}');

                    },
                    child: const SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(
                        Icons.play_circle_outline,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Play Video',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ) : const SizedBox(height: 0, width: 0,),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Description: The Sign means Thsi This This....",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Example: I love you more than the stars and sky....",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ],
      ),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  final String text;

  const ChoiceButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        backgroundColor: Colors.blue[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        // Handle button press
      },
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}

class DescriptionScreenArguments {
  final String name;
  final dynamic file;

  DescriptionScreenArguments({required this.file, required this.name});
}
