//  Created by Crt Vavros, copyright © 2022 ZeroPass. All rights reserved.

// Class contains information eMRTD application applet (DF1)
import 'package:mrzflutterplugin_example/dmrtd_lib/extensions.dart';

class DF1 {
  // See: Section 3.1 https://www.icao.int/publications/Documents/9303_p10_cons_en.pdf
  // ignore: non_constant_identifier_names
  static final AID  = "A0000002471001".parseHex();
  static const name = "eMRTD Application";
}