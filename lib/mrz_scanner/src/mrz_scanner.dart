import 'package:flutter/material.dart';


import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';


import 'package:mrzflutterplugin_example/mrz_parser/src/mrz_parser.dart';


import 'package:mrzflutterplugin_example/mrz_parser/src/mrz_result.dart';


import 'package:mrzflutterplugin_example/mrz_scanner/mrz_scanner.dart';


import 'camera_view.dart';


import 'mrz_helper.dart';


class MRZScanner extends StatefulWidget {

  const MRZScanner({

    Key? controller,

    required this.onSuccess,

    this.initialDirection = CameraLensDirection.back,

    this.showOverlay = true,

  }) : super(key: controller);


  final Function(MRZResult mrzResult, List<String> lines) onSuccess;


  final CameraLensDirection initialDirection;


  final bool showOverlay;


  @override


  // ignore: library_private_types_in_public_api


  MRZScannerState createState() => MRZScannerState();

}


class MRZScannerState extends State<MRZScanner> {

  final TextRecognizer _textRecognizer = TextRecognizer();


  bool _canProcess = true;


  bool _isBusy = false;


  List result = [];


  void resetScanning() => _isBusy = false;


  @override

  void dispose() async {

    _canProcess = false;


    _textRecognizer.close();


    super.dispose();

  }


  @override

  Widget build(BuildContext context) {

    return MRZCameraView(

      showOverlay: widget.showOverlay,

      initialDirection: widget.initialDirection,

      onImage: _processImage,

    );

  }


  void _parseScannedText(List<String> lines) {

    try {

      final data = MRZParser.parse(lines);


      _isBusy = true;


      widget.onSuccess(data, lines);

    } catch (e) {

      _isBusy = false;

    }

  }


  List results = [];


  Future<void> _processImage(InputImage inputImage) async {

    if (!_canProcess) return;


    if (_isBusy) return;


    _isBusy = true;


    final recognizedText = await _textRecognizer.processImage(inputImage);


    String fullText = recognizedText.text;


    String trimmedText = fullText.replaceAll(' ', '');


    List allText = trimmedText.split('\n');


    List<String> ableToScanText = [];


    for (var e in allText) {

      if (MRZHelper.testTextLine(e).isNotEmpty) {

        ableToScanText.add(MRZHelper.testTextLine(e));

      }

    }


    List<String>? result = MRZHelper.getFinalListToParse([...ableToScanText]);


    // print(results);


    if (result != null) {

      // if (results.length == 3 &&


      //     results[2] == results[1] &&


      //     results[2] == results[0]) {


      //   _parseScannedText([...result]);


      //   return;


      // }


      if (results.length == 3) {

        _parseScannedText([...result]);

      }


      results.add(result.join());


      if (results.length > 3) {

        results.removeAt(0);

      }


      // print(results);


      _isBusy = false;


      // if (results.length == 3 &&


      //     result[0] == results.first &&


      //     result[0] == results[1]) {


      //   _isBusy = false;


      //   print('success$results');


      // } else if (results.length > 3) {


      //   print('remove first');


      //   print('results$results');


      //   results.remove(results[0]);


      //   _isBusy = false;


      // }

    } else {

      print('result null');


      _isBusy = false;

    }


    // if (result != null) {


    //   _parseScannedText([...result]);


    // } else {


    //   _isBusy = false;


    // }

  }

}

