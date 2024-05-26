import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speaking_note/screen_sizes.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Speaking Notes',
      //title: Image.asset('assets/images/easydoubt.png', fit: BoxFit.cover),
      home: SplashScreen(),

    );
  }
}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a time-consuming task (e.g., loading data) for the splash screen.
    // Replace this with your actual data loading logic.


    //child: Text('Goto Next Page')),


    Future.delayed(
      Duration(seconds: 8),
          () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyHomePage()));
        // Navigator.pushReplacementNamed(context, '/home');
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(


        backgroundColor: Colors.blueAccent,
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[

                Container(
                  width: displayWidth(context) * 0.25,
                  height: displayHeight(context) * 0.25,
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                  ),
                  child: Image.asset('assets/images/microphone.png',),
                ),

                //Image.asset('assets/images/book.png'),
              //  Image.asset('assets/images/microphone.png'),
                LoadingAnimationWidget.staggeredDotsWave(color: Colors.white, size: 100)
                // LoadingAnimationWidget.staggeredDotsWave(
                //   //color: Colors.white,
                //   size: 100, leftDotColor: Colors.blue, rightDotColor: Colors.red,
                // )
              ]
          ),




        )

    );
  }

}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _getdata = TextEditingController();
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    //_lastWords='';
    await _speechToText.stop();
    setState(() {});
    _getdata.text=_getdata.text.toString()+' '+_lastWords;
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords='';
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Row(
          children: <Widget>[
            Text(
              'Speaking Notes',
              style: TextStyle(
                color: Colors.white,
              ),
            ),

            Container(
              width: displayWidth(context) * 0.07,
              height: displayHeight(context) * 0.07,
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
              ),
              child: Image.asset('assets/images/microphone.png',),
            ),

          //  Image.asset('assets/images/microphone.png',  width: displayWidth(context) * 0.07,
            //  height: displayHeight(context) * 0.07,)
          ],
        ),



      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                style: TextStyle(fontSize: 25),

                // If listening is active show the recognized words
                _speechToText.isListening
                    ? '$_lastWords'
                // If listening isn't active but could be tell the user
                // how to start it, otherwise indicate that speech
                // recognition is not yet ready or not supported on
                // the target device
                    : _speechEnabled
                    ? 'Tap to start listening....'
                    : 'Speech not available',
              ),
              // child: Text(
              //   'Recognized words:',
              //   style: TextStyle(fontSize: 20.0),
              // ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                //width=displayWidth.width*20;
                width: displayWidth(context) * 0.75,
                height: displayHeight(context) * 0.7,
                // width: 300,
                // height:100,
                decoration:BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      width: 2.0,
                      color: Colors.blueAccent,
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: TextField(
                    controller: _getdata,
                    minLines: 1,
                    maxLines: null,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    // decoration:  InputDecoration(
                    //   enabledBorder: OutlineInputBorder(
                    //     borderRadius: BorderRadius.all(Radius.circular(4)),
                    //
                    //     borderSide: BorderSide(
                    //         width: 2, color: Colors.blue),
                    //     //<-- SEE HERE
                    //   ),
                    // ),

                  ),
                ),
              ),
            ),
          ],

        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
        // If not yet listening for speech start, otherwise stop
        _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        backgroundColor: Colors.blueAccent,
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic,color:Colors.white,),
        splashColor:Colors.white,

      ),
    );
  }
}
