import 'package:flutter/material.dart';

class TranscribeScreen extends StatelessWidget {
  static const String routeName = '/transcribe';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text('Quiz'),
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
                  )),
            ],
          ),
          Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "What Does The Sign Mean ?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: 300,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    )),
                child: Hero(
                  tag: 'hero_picture',
                  child: Image.asset(
                    'assets/images/sign.png',
                    width: 270,
                    height: 300,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChoiceButton(text: '    LE    '),
                  ChoiceButton(text: '    HA    '),
                ],
              ),
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChoiceButton(text: '    RA    '),
                  ChoiceButton(text: '    SE    '),
                ],
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



// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'dart:typed_data';

// import '../main.dart';


// class TranscribeScreen extends StatefulWidget {
//   static const String routeName = '/transcribe';

//   @override
//   _TranscribeScreenState createState() => _TranscribeScreenState();
// }

// class _TranscribeScreenState extends State<TranscribeScreen> {
//   bool _isTranscribing = false;
//   String _translation = '';
//   late CameraController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(cameras[0], ResolutionPreset.max);
//     _controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     }).catchError((Object e) {
//       if (e is CameraException) {
//         switch (e.code) {
//           case 'CameraAccessDenied':
//             // Handle access errors here.
//             break;
//           default:
//             // Handle other errors here.
//             break;
//         }
//       }
//     });
//   }
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _transcribe() async {
//     setState(() {
//       _isTranscribing = true;
//       _translation = '';
//     });

//     try {
//       // Capture a single frame
//       XFile picture = await _controller.takePicture();
//       Uint8List bytes = await picture.readAsBytes();
//       String base64Image = base64Encode(bytes);

//       // Log the request data
//       print(
//           'Request Data: ${base64Image.substring(0, 100)}...'); // Print first 100 characters for brevity

//       // Send to the server for translation
//       final response = await http.post(
//         Uri.parse('http://10.240.71.63:5000/frame'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'image': base64Image}),
//       );

//       // Log the response data
//       print('Response Status Code: ${response.statusCode}');
//       print('Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         setState(() {
//           _translation = decoded['translation'] ?? 'No translation available';
//         });
//       } else {
//         setState(() {
//           _translation = 'Error: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _translation = 'Error: ${e.toString()}';
//       });
//     }

//     setState(() {
//       _isTranscribing = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_controller.value.isInitialized) {
//       return Container();
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sign Language Translator'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: CameraPreview(_controller),
//           ),
//           SizedBox(height: 16.0),
//           _isTranscribing
//               ? CircularProgressIndicator()
//               : ElevatedButton(
//                   onPressed: _transcribe,
//                   child: Text('Transcribe'),
//                 ),
//           SizedBox(height: 16.0),
//           Text(
//             _translation,
//             style: TextStyle(fontSize: 24.0),
//           ),
//           SizedBox(height: 16.0),
//         ],
//       ),
//     );
//   }
// }