// Created by Crt Vavros, copyright © 2022 ZeroPass. All rights reserved.
// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:convert/convert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/com/nfc_provider.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/crypto/aa_pubkey.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/df1/dg.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/df1/efcom.dart';

import 'package:mrzflutterplugin_example/dmrtd_lib/extensions.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/df1/efdg1.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/df1/efdg10.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/df1/efdg11.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/df1/efdg12.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/df1/efdg13.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/df1/efdg14.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/df1/efdg15.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/df1/efdg16.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/df1/efdg2.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/df1/efdg3.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/df1/efdg4.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/df1/efdg5.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/df1/efdg6.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/df1/efdg7.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/df1/efdg8.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/df1/efdg9.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/df1/efsod.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/efcard_access.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/efcard_security.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/mrz.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/lds/tlv.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/passport.dart';
import 'package:mrzflutterplugin_example/dmrtd_lib/src/proto/dba_keys.dart';
import 'package:mrzflutterplugin_example/screen/colored_button.dart';
import 'package:mrzflutterplugin_example/screen/date_converter.dart';
import 'package:mrzflutterplugin_example/screen/jpeg2000_converter.dart';

import '../../mrz_parser/src/mrz_result.dart';

class MrtdData {
  EfCardAccess? cardAccess;
  EfCardSecurity? cardSecurity;
  EfCOM? com;
  EfSOD? sod;
  EfDG1? dg1;
  EfDG2? dg2;
  EfDG3? dg3;
  EfDG4? dg4;
  EfDG5? dg5;
  EfDG6? dg6;
  EfDG7? dg7;
  EfDG8? dg8;
  EfDG9? dg9;
  EfDG10? dg10;
  EfDG11? dg11;
  EfDG12? dg12;
  EfDG13? dg13;
  EfDG14? dg14;
  EfDG15? dg15;
  EfDG16? dg16;
  Uint8List? aaSig;
}

final Map<DgTag, String> dgTagToString = {
  EfDG1.TAG: 'EF.DG1',
  EfDG2.TAG: 'EF.DG2',
  EfDG3.TAG: 'EF.DG3',
  EfDG4.TAG: 'EF.DG4',
  EfDG5.TAG: 'EF.DG5',
  EfDG6.TAG: 'EF.DG6',
  EfDG7.TAG: 'EF.DG7',
  EfDG8.TAG: 'EF.DG8',
  EfDG9.TAG: 'EF.DG9',
  EfDG10.TAG: 'EF.DG10',
  EfDG11.TAG: 'EF.DG11',
  EfDG12.TAG: 'EF.DG12',
  EfDG13.TAG: 'EF.DG13',
  EfDG14.TAG: 'EF.DG14',
  EfDG15.TAG: 'EF.DG15',
  EfDG16.TAG: 'EF.DG16'
};

String formatEfCom(final EfCOM efCom) {
  var str = "version: ${efCom.version}\n"
      "unicode version: ${efCom.unicodeVersion}\n"
      "DG tags:";

  for (final t in efCom.dgTags) {
    try {
      str += " ${dgTagToString[t]!}";
    } catch (e) {
      str += " 0x${t.value.toRadixString(16)}";
    }
  }
  return str;
}

String formatMRZ(final MRZ mrz) {
  return "MRZ\n"
          "Version: ${mrz.version}\n" +
      "Document Type: ${mrz.documentCode}\n" +
      "Document Number: ${mrz.documentNumber}\n" +
      "Country: ${mrz.country}\n" +
      "Nationality: ${mrz.nationality}\n" +
      "Name: ${mrz.firstName}\n" +
      "Surname: ${mrz.lastName}\n" +
      "Gender: ${mrz.gender}\n" +
      "Date of Birth: ${DateFormat.yMd().format(mrz.dateOfBirth)}\n" +
      "Date of Expiry: ${DateFormat.yMd().format(mrz.dateOfExpiry)}\n" +
      "Additional data 1: ${mrz.optionalData}\n" +
      "Additional data 2: ${mrz.optionalData2 ?? 'None'}";
}

String formatDG2(final EfDG2 dg2) {
  return "DG2\n"
          "faceImageType ${dg2.faceImageType}\n" +
      "facialRecordDataLength ${dg2.facialRecordDataLength}\n" +
      "imageHeight ${dg2.imageHeight}\n" +
      "imageType: ${dg2.imageType}\n" +
      "lengthOfRecord ${dg2.lengthOfRecord}\n" +
      "numberOfFacialImages ${dg2.numberOfFacialImages}\n" +
      "poseAngle ${dg2.poseAngle}";
}

String convertToReadableFormat(String input) {
  if (input.isEmpty) {
    return input;
  }

  String readableText = input.replaceAll('_', ' ');

  return readableText;
}

String formatDG15(final EfDG15 dg15) {
  var str = "EF.DG15:\n"
      "AAPublicKey\n"
      "type: ";

  final rawSubPubKey = dg15.aaPublicKey.rawSubjectPublicKey();
  if (dg15.aaPublicKey.type == AAPublicKeyType.RSA) {
    final tvSubPubKey = TLV.fromBytes(rawSubPubKey);
    var rawSeq = tvSubPubKey.value;
    if (rawSeq[0] == 0x00) {
      rawSeq = rawSeq.sublist(1);
    }

    final tvKeySeq = TLV.fromBytes(rawSeq);
    final tvModule = TLV.decode(tvKeySeq.value);
    final tvExp = TLV.decode(tvKeySeq.value.sublist(tvModule.encodedLen));

    str += "RSA\n"
        "exponent: ${tvExp.value.hex()}\n"
        "modulus: ${tvModule.value.hex()}";
  } else {
    str += "EC\n    SubjectPublicKey: ${rawSubPubKey.hex()}";
  }
  return str;
}

String formatProgressMsg(String message, int percentProgress) {
  final p = (percentProgress / 20).round();
  final full = "🟢 " * p;
  final empty = "⚪️ " * (5 - p);
  return message + "\n\n" + full + empty;
}

class NFCReaderScreen extends StatelessWidget {
  const NFCReaderScreen({super.key, required this.mrzResult});
  final MRZResult mrzResult;

  @override
  Widget build(BuildContext context) {
    return MrtdHomePage(
      mrzResult: mrzResult,
    );
  }
}

class MrtdHomePage extends StatefulWidget {
  const MrtdHomePage({super.key, required this.mrzResult});
  final MRZResult mrzResult;

  @override
  // ignore: library_private_types_in_public_api
  _MrtdHomePageState createState() => _MrtdHomePageState();
}

class _MrtdHomePageState extends State<MrtdHomePage> {
  var _alertMessage = "";
  final _log = Logger("mrtdeg.app");
  var _isNfcAvailable = false;
  var _isReading = false;
  // final _mrzData = GlobalKey<FormState>();

  // mrz data
  String? docNumber;
  String? dob; // date of birth
  String? doe; // date of doc expiry

  MrtdData? _mrtdData;

  final NfcProvider _nfc = NfcProvider();
  // ignore: unused_field
  late Timer _timerStateUpdater;
  final _scrollController = ScrollController();

  @override
  void initState() {
    docNumber = widget.mrzResult.documentNumber;

    dob = convertDateTimeToDateString(widget.mrzResult.birthDate);

    doe = convertDateTimeToDateString(widget.mrzResult.expiryDate);

    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _initPlatformState();

    // Update platform state every 3 sec
    // _timerStateUpdater = Timer.periodic(const Duration(seconds: 3), (Timer t) {
    //   _initPlatformState();
    // });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initPlatformState() async {
    bool isNfcAvailable;
    try {
      NfcStatus status = await NfcProvider.nfcStatus;
      isNfcAvailable = status == NfcStatus.enabled;
    } on PlatformException {
      isNfcAvailable = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _isNfcAvailable = isNfcAvailable;
    setState(() {});
    if (_isNfcAvailable == false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Couldn't access device NFC, please try again")));
    }
  }

  DateTime? _getDOBDate() {
    if (dob!.isEmpty) {
      return null;
    }

    return DateFormat.yMd().parse(dob!);
  }

  DateTime? _getDOEDate() {
    if (doe!.isEmpty) {
      return null;
    }
    return DateFormat.yMd().parse(doe!);
  }

  Uint8List? rawImageData;
  Uint8List? rawHandSignatureData;

  void _readMRTD() async {
    try {
      setState(() {
        _mrtdData = null;
        _alertMessage = "Waiting for Document tag ...";
        _isReading = true;
      });

      await _nfc.connect(
          iosAlertMessage: "Hold your phone near Biometric Document");
      final passport = Passport(_nfc);

      setState(() {
        _alertMessage = "Reading Document ...";
      });

      _nfc.setIosAlertMessage("Trying to read EF.CardAccess ...");
      final mrtdData = MrtdData();

      try {
        mrtdData.cardAccess = await passport.readEfCardAccess();
      } on PassportError {
        //if (e.code != StatusWord.fileNotFound) rethrow;
      }

      _nfc.setIosAlertMessage("Trying to read EF.CardSecurity ...");

      try {
        mrtdData.cardSecurity = await passport.readEfCardSecurity();
      } on PassportError {
        //if (e.code != StatusWord.fileNotFound) rethrow;
      }

      _nfc.setIosAlertMessage("Initiating session ...");
      final bacKeySeed = DBAKeys(docNumber!, _getDOBDate()!, _getDOEDate()!);
      await passport.startSession(bacKeySeed);

      _nfc.setIosAlertMessage(formatProgressMsg("Reading EF.COM ...", 0));
      mrtdData.com = await passport.readEfCOM();

      _nfc.setIosAlertMessage(formatProgressMsg("Reading Data Groups ...", 20));

      if (mrtdData.com!.dgTags.contains(EfDG1.TAG)) {
        mrtdData.dg1 = await passport.readEfDG1();
      }

      if (mrtdData.com!.dgTags.contains(EfDG2.TAG)) {
        mrtdData.dg2 = await passport.readEfDG2();
      }

      // To read DG3 and DG4 session has to be established with CVCA certificate (not supported).
      // if(mrtdData.com!.dgTags.contains(EfDG3.TAG)) {
      // mrtdData.dg3 = await passport.readEfDG3();
      // }

      // if(mrtdData.com!.dgTags.contains(EfDG4.TAG)) {
      // mrtdData.dg4 = await passport.readEfDG4();
      // }

      if (mrtdData.com!.dgTags.contains(EfDG5.TAG)) {
        mrtdData.dg5 = await passport.readEfDG5();
      }

      if (mrtdData.com!.dgTags.contains(EfDG6.TAG)) {
        mrtdData.dg6 = await passport.readEfDG6();
      }

      if (mrtdData.com!.dgTags.contains(EfDG7.TAG)) {
        mrtdData.dg7 = await passport.readEfDG7();

        String? imageHex = extractImageData(mrtdData.dg7!.toBytes().hex());

        Uint8List? decodeImageHex =
            Uint8List.fromList(List<int>.from(hex.decode(imageHex)));
        rawHandSignatureData = decodeImageHex;
      }

      // String? imageHex = extractImageData(handSign);

      // Uint8List? decodeImageHex =
      //     Uint8List.fromList(List<int>.from(hex.decode(imageHex)));
      // rawHandSignatureData = decodeImageHex;

      if (mrtdData.com!.dgTags.contains(EfDG8.TAG)) {
        mrtdData.dg8 = await passport.readEfDG8();
      }

      if (mrtdData.com!.dgTags.contains(EfDG9.TAG)) {
        mrtdData.dg9 = await passport.readEfDG9();
      }

      if (mrtdData.com!.dgTags.contains(EfDG10.TAG)) {
        mrtdData.dg10 = await passport.readEfDG10();
      }

      if (mrtdData.com!.dgTags.contains(EfDG11.TAG)) {
        mrtdData.dg11 = await passport.readEfDG11();
      }

      if (mrtdData.com!.dgTags.contains(EfDG12.TAG)) {
        mrtdData.dg12 = await passport.readEfDG12();
      }

      if (mrtdData.com!.dgTags.contains(EfDG13.TAG)) {
        mrtdData.dg13 = await passport.readEfDG13();
      }

      if (mrtdData.com!.dgTags.contains(EfDG14.TAG)) {
        mrtdData.dg14 = await passport.readEfDG14();
      }

      if (mrtdData.com!.dgTags.contains(EfDG15.TAG)) {
        mrtdData.dg15 = await passport.readEfDG15();
        _nfc.setIosAlertMessage(formatProgressMsg("Doing AA ...", 60));
        mrtdData.aaSig = await passport.activeAuthenticate(Uint8List(8));
      }

      if (mrtdData.com!.dgTags.contains(EfDG16.TAG)) {
        mrtdData.dg16 = await passport.readEfDG16();
      }

      _nfc.setIosAlertMessage(formatProgressMsg("Reading EF.SOD ...", 80));
      mrtdData.sod = await passport.readEfSOD();

      _mrtdData = mrtdData;

      _alertMessage = "";

      if (mrtdData.dg2?.imageData != null) {
        rawImageData = mrtdData.dg2?.imageData;
        tryDisplayingJpg();
        //await tryDisplayingJp2();
      }
      _scrollController.animateTo(300.0,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);

      setState(() {});
    } on Exception catch (e) {
      final se = e.toString().toLowerCase();
      String alertMsg = "An error has occurred while reading Document!";
      if (e is PassportError) {
        if (se.contains("security status not satisfied")) {
          alertMsg =
              "Failed to initiate session with passport.\nCheck input data!";
        }
        _log.error("PassportError: ${e.message}");
      } else {
        _log.error(
            "An exception was encountered while trying to read Document: $e");
      }

      if (se.contains('timeout')) {
        alertMsg = "Timeout while waiting for Document tag";
      } else if (se.contains("tag was lost")) {
        alertMsg = "Tag was lost. Please try again!";
      } else if (se.contains("invalidated by user")) {
        alertMsg = "";
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(se)));

      setState(() {
        _alertMessage = alertMsg;
      });
    } finally {
      if (_alertMessage.isNotEmpty) {
        await _nfc.disconnect(iosErrorMessage: _alertMessage);
      } else {
        await _nfc.disconnect(
            iosAlertMessage: formatProgressMsg("Finished", 100));
      }

      setState(() {
        _isReading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildPage(context);
  }

  String extractImageData(String inputHex) {
    // Find the index of the first occurrence of 'FFD8'
    int startIndex = inputHex.indexOf('ffd8');
    // Find the index of the first occurrence of 'FFD9'
    int endIndex = inputHex.indexOf('ffd9');

    // If both 'FFD8' and 'FFD9' are found, extract the substring between them
    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      String extractedImageData = inputHex.substring(
          startIndex, endIndex + 4); // Include 'FFD9' in the substring

      // Return the extracted image data
      return extractedImageData;
    } else {
      // 'FFD8' or 'FFD9' not found, handle accordingly (e.g., return an error or the original input)
      print("FFD8 and/or FFD9 markers not found in the input hex string.");
      return inputHex;
    }
  }

  Widget _makeMrtdDataWidget(
      {required String? header,
      required String collapsedText,
      required String? dataText}) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      title: Text(header ?? ""),
      onLongPress: () =>
          Clipboard.setData(ClipboardData(text: dataText ?? "Null")),
      subtitle: SelectableText(dataText ?? "Null", textAlign: TextAlign.left),
      trailing: IconButton(
        icon: const Icon(
          Icons.copy,
        ),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: dataText ?? "Null"));
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Copied")));
        },
      ),
    );
  }

  List<Widget> _mrtdDataWidgets() {
    List<Widget> list = [];
    if (_mrtdData == null) return list;

    if (_mrtdData?.dg1 != null) {
      list.add(_makeMrtdDataWidget(
          header: null,
          collapsedText: '',
          dataText: formatMRZ(_mrtdData!.dg1!.mrz)));
    }

    // if (_mrtdData?.cardAccess != null) {
    //   list.add(_makeMrtdDataWidget(
    //       header: 'EF.CardAccess',
    //       collapsedText: '',
    //       dataText: _mrtdData?.cardAccess?.toBytes().hex()));
    // }

    // if (_mrtdData?.cardSecurity != null) {
    //   list.add(_makeMrtdDataWidget(
    //       header: 'EF.CardSecurity',
    //       collapsedText: '',
    //       dataText: _mrtdData?.cardSecurity?.toBytes().hex()));
    // }

    // if (_mrtdData?.sod != null) {
    //   list.add(_makeMrtdDataWidget(
    //       header: 'EF.SOD',
    //       collapsedText: '',
    //       dataText: _mrtdData?.sod?.toBytes().hex()));
    // }

    // if (_mrtdData?.com != null) {
    //   list.add(_makeMrtdDataWidget(
    //       header: 'EF.COM',
    //       collapsedText: '',
    //       dataText: formatEfCom(_mrtdData!.com!)));
    // }

    // if (_mrtdData?.dg2 != null) {
    // list.add(_makeMrtdDataWidget(
    //     header: 'EF.DG2',
    //     collapsedText: '',
    //     dataText: formatDG2(_mrtdData!.dg2!)));
    // }

    // if (_mrtdData?.dg3 != null) {
    // list.add(_makeMrtdDataWidget(
    //     header: 'EF.DG3',
    //     collapsedText: '',
    //     dataText: _mrtdData?.dg3?.toBytes().hex()));
    // }

    // if (_mrtdData?.dg4 != null) {
    // list.add(_makeMrtdDataWidget(
    //     header: 'EF.DG4',
    //     collapsedText: '',
    //     dataText: _mrtdData?.dg4?.toBytes().hex()));
    // }

    // if (_mrtdData?.dg5 != null) {
    // list.add(_makeMrtdDataWidget(
    //     header: 'EF.DG5',
    //     collapsedText: '',
    //     dataText: _mrtdData?.dg5?.toBytes().hex()));
    // }

    // if (_mrtdData?.dg6 != null) {
    // list.add(_makeMrtdDataWidget(
    //     header: 'EF.DG6',
    //     collapsedText: '',
    //     dataText: _mrtdData?.dg6?.toBytes().hex()));
    // }

    // list.add(_makeMrtdDataWidget(
    //     header: 'EF.DG7',
    //     collapsedText: '',
    //     dataText: _mrtdData?.dg7?.toBytes().toString()));

    // if (_mrtdData?.dg8 != null) {
    // list.add(_makeMrtdDataWidget(
    //     header: 'EF.DG8',
    //     collapsedText: '',
    //     dataText: _mrtdData?.dg8?.toBytes().hex()));
    // }

    // if (_mrtdData?.dg9 != null) {
    // list.add(_makeMrtdDataWidget(
    //     header: 'EF.DG9',
    //     collapsedText: '',
    //     dataText: _mrtdData?.dg9?.toBytes().hex()));
    // }

    // if (_mrtdData?.dg10 != null) {
    // list.add(_makeMrtdDataWidget(
    //     header: 'EF.DG10',
    //     collapsedText: '',
    //     dataText: _mrtdData?.dg10?.toBytes().hex()));
    // }

    // if (_mrtdData?.dg11 != null) {
    // list.add(_makeMrtdDataWidget(
    //     header: 'EF.DG11',
    //     collapsedText: '',
    //     dataText: _mrtdData?.dg11?.toBytes().hex()));
    // }

    // if (_mrtdData?.dg12 != null) {
    // list.add(_makeMrtdDataWidget(
    //     header: 'EF.DG12',
    //     collapsedText: '',
    //     dataText: _mrtdData?.dg12?.toBytes().hex()));
    // }

    // if (_mrtdData?.dg13 != null) {
    // list.add(_makeMrtdDataWidget(
    //     header: 'EF.DG13',
    //     collapsedText: '',
    //     dataText: _mrtdData?.dg13?.toBytes().hex()));
    // }

    // if (_mrtdData?.dg14 != null) {
    // list.add(_makeMrtdDataWidget(
    //     header: 'EF.DG14',
    //     collapsedText: '',
    //     dataText: _mrtdData?.dg14?.toBytes().hex()));
    // }

    // if (_mrtdData?.dg15 != null) {
    // list.add(_makeMrtdDataWidget(
    //     header: 'EF.DG15',
    //     collapsedText: '',
    //     dataText: formatDG15(_mrtdData!.dg15!)));
    // }

    // if (_mrtdData?.aaSig != null) {
    //   list.add(_makeMrtdDataWidget(
    //       header: 'Active Authentication signature',
    //       collapsedText: '',
    //       dataText: _mrtdData?.aaSig!.hex()));
    // }

    // if (_mrtdData?.dg16 != null) {
    // list.add(_makeMrtdDataWidget(
    //     header: 'EF.DG16',
    //     collapsedText: '',
    //     dataText: _mrtdData?.dg16?.toBytes().hex()));
    // }

    return list;
  }

  Scaffold _buildPage(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('NFC Scan')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Device NFC available:',
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                        const SizedBox(width: 4),
                        Text(_isNfcAvailable ? "Yes" : "No",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: _isNfcAvailable
                                    ? Colors.green
                                    : Colors.red))
                      ]),
                  const SizedBox(height: 40),
                  if (_isNfcAvailable && _isReading)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: CupertinoActivityIndicator(
                        color: Colors.black,
                        radius: 18,
                      ),
                    ),
                  if (_isNfcAvailable && !_isReading)
                    Center(
                        child: ColoredButton(
                      iconData: Icons.nfc_outlined,
                      // btn Read MRTD
                      onPressed: () {
                        _initPlatformState();
                        
                        // Future.delayed(Duration(seconds: 2)).then((value) {
                        //   _readMRTD();
                        // });
                        _readMRTD();
                      },
                      child: Text('Start Scan'),
                    )),
                  if (!_isNfcAvailable && !_isReading)
                    Center(
                        child: ColoredButton(
                      iconData: Icons.nfc_outlined,
                      // btn Read MRTD
                      onPressed: () {
                        _initPlatformState();
                      },
                      child: Text('NFC Scan'),
                    )),
                  const SizedBox(height: 10),
                  Text(_alertMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),

                  // TextButton(
                  //   child: Text("Export as jp2"),
                  //   onPressed: () {
                  //     saveJp2();
                  //   },
                  // ),
                  // TextButton(
                  //   child: Text("Export as jpg"),
                  //   onPressed: () {
                  //     saveJpeg();
                  //   },
                  // ),
                  // TextButton(
                  //   child: Text("Try Jpg"),
                  //   onPressed: () {
                  //     tryDisplayingJpg();
                  //   },
                  // ),

                  if (jpegImage != null || jp2000Image != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Image",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),

                  if (jpegImage != null)
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            jpegImage!,
                            errorBuilder: (context, error, stackTrace) =>
                                SizedBox(),
                          ),
                        ),
                      ],
                    ),

                  if (jp2000Image != null)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              jp2000Image!,
                              errorBuilder: (context, error, stackTrace) =>
                                  SizedBox(),
                            )),
                      ],
                    ),

                  if (rawHandSignatureData != null)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text("Signature",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        SizedBox(
                          height: 10,
                        ),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              rawHandSignatureData!,
                              errorBuilder: (context, error, stackTrace) =>
                                  SizedBox(),
                            )),
                      ],
                    ),

                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(_mrtdData != null ? "NFC Scan Data:" : "",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold)),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _mrtdDataWidgets())
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Uint8List? jpegImage;
  Uint8List? jp2000Image;

  void tryDisplayingJpg() {
    try {
      jpegImage = rawImageData;

      setState(() {});
    } catch (e) {
      jpegImage = null;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Image is not in jpg format, trying jpeg2000")));
    }
  }

  void tryDisplayingJp2() async {
    try {
      jp2000Image = await decodeImage(rawImageData!, context);
      setState(() {});
    } catch (e) {
      jpegImage = null;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Image is not in jpeg2000")));
    }
  }
}
