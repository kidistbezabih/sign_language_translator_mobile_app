import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<CameraDescription> cameras = await availableCameras();
  runApp(TranscribeScreen(cameras: cameras));
}

class TranscribeScreen extends StatelessWidget {
  final List<CameraDescription> cameras;

  const TranscribeScreen({super.key, required this.cameras });
  static const String routeName = '/transcribe';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Language Translator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TranscribePage(cameras: cameras),
    );
  }
}


class TranscribePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const TranscribePage({super.key, required this.cameras});

  @override
  _TranscribePageState createState() => _TranscribePageState();
}

class _TranscribePageState extends State<TranscribePage> {
  late CameraController _controller;
  bool _isTranscribing = false;
  String _translation = '';

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.medium,
    );
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  Future<void> _transcribe() async {
    setState(() {
      _isTranscribing = true;
      _translation = '';
    });
    
    try {
      XFile picture = await _controller.takePicture();
      Uint8List bytes = await picture.readAsBytes();
      String base64Image = base64Encode(bytes);

      // Log the request data
      print(
            'Request Data: ${base64Image.substring(0, 100)}...'); // Print first 100 characters for brevity


      final response = await http.post(
        Uri.parse('http://10.240.71.63:5000/frame'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'image': base64Image}),
        );
      // Log the response data
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() {
          _translation =
              decoded['translation'] ?? ' የማይታወቅ ቃል!'; // Success message color
        });
      } else if (response.statusCode == 400) {
        setState(() {
          _translation = 'ምልክቱ እየታየ አይደለም፣ እንደገና ይሞከሩ!'; // Error message color
        });
      } else if (response.statusCode == 500) {
        setState(() {
          _translation = ' አገልግሎቱ ተቋርጧል!'; // Error message color
        });
      } else {
        setState(() {
          _translation = 'ያልተጠበቀ ችግር፣ እንደገና ይሞከሩ።';
        });
      }
    } catch (e) {
      setState(() {
        _translation = 'ምሰል የመግራት ሂደት ችግር!'; // Error message color
      });
    }

    setState(() {
      _isTranscribing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!_controller.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('የምልክት ቋንቋ ኣስተርጓሚ'),
      ),
           body: Column(
        children: <Widget>[
          Expanded(
            child: CameraPreview(_controller),
          ),
          SizedBox(height: 16.0),
          _isTranscribing
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _transcribe,
                  child: Text('ተርጉም'),
                ),
          SizedBox(height: 16.0),
          Text(
            _translation,
            style: TextStyle(fontSize: 24.0),
          ),
          SizedBox(height: 16.0),
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
