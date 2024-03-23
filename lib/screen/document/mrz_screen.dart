import 'package:flutter/material.dart';

import 'package:mrzflutterplugin_example/mrz_scanner/src/mrz_scanner.dart';
import 'package:mrzflutterplugin_example/screen/nfc/nfc_reader_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../mrz_scanner/src/mrz_controller.dart';

class MrzScreen extends StatefulWidget {
  @override
  State<MrzScreen> createState() => _MrzScreenState();
}

class _MrzScreenState extends State<MrzScreen> {
  final MRZController controller = MRZController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<PermissionStatus>(
        future: Permission.camera.request(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == PermissionStatus.granted) {
            return MZ();
          }
          if (snapshot.data == PermissionStatus.permanentlyDenied) {
            // The user opted to never again see the permission request dialog for this
            // app. The only way to change the permission's status now is to let the
            // user manually enable it in the system settings.
            openAppSettings();
          }
          return Center(
            child: SizedBox(
              child: TextButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: Text("Grant Camera Permission")),
            ),
          );
        },
      ),
    );
  }
}

class MZ extends StatefulWidget {
  @override
  State<MZ> createState() => _MZState();
}

class _MZState extends State<MZ> {
  final MRZController controller = MRZController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MRZScanner(
        controller: controller,
        showOverlay: true,
        onSuccess: (mrzResult, lines) async {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NFCReaderScreen(mrzResult: mrzResult),
              ));
        },
      );
    });
  }
}
