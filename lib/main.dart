import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:mrzflutterplugin_example/screen/colored_button.dart';
import 'package:mrzflutterplugin_example/screen/document/mrz_screen.dart';

void main() {
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print(
          '${record.loggerName} ${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Kazi Tour ID",
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white)),
      home: const NfcApp(),
    );
  }
}

class NfcApp extends StatelessWidget {
  const NfcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Kazi Tour ID",
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                "assets/app_banner.jpg",
              ),
              // Spacer(),
              const Text(
                "Scan Pasports or Identity cards",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: const Text(
                  "Click on the button below to start scanning",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              ColoredButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MrzScreen(),
                      ));
                },
                child: const Text(
                  "Scan Document",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                iconData: Icons.camera_alt_rounded,
              ),
              const SizedBox(
                height: 20,
              ),
              // ColoredButton(
              //     onPressed: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => const IdentityCardScreen(),
              //           ));
              //     },
              //     child: const Text(
              //       "Identity Card",
              //       style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //       ),
              //     )),
              // const SizedBox(
              //   height: 20,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
