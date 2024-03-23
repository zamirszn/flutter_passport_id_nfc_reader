## Scan Document Button

The `ColoredButton` widget is used to create a button that initiates the scanning of a document, such as a passport or identity card. This button is designed to navigate to the `MrzScreen` when pressed.

### Usage

```dart
ColoredButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MrzScreen(),
      ),
    );
  },
  child: const Text(
    "Scan Document",
    style: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),
  iconData: Icons.camera_alt_rounded,
),
```

# Camera Permission Handling

The following Flutter code snippet demonstrates how to handle camera permission within a `Scaffold`. This implementation utilizes the `permission_handler` package.

## Usage

```dart
Scaffold(
  appBar: AppBar(),
  body: FutureBuilder<PermissionStatus>(
    // Request camera permission asynchronously
    future: Permission.camera.request(),
    builder: (context, snapshot) {
      // Check if permission is granted
      if (snapshot.hasData && snapshot.data == PermissionStatus.granted) {
        // If granted, display the MRZ scanning screen (replace 'MZ()' with your actual MRZ scanning widget)
        return MZ();
      }

      // If permission is permanently denied, prompt the user to enable it in system settings
      if (snapshot.data == PermissionStatus.permanentlyDenied) {
        openAppSettings(); // Open system settings for the app
      }

      // If permission is not granted or permanently denied, show a button to request permission
      return Center(
        child: SizedBox(
          child: TextButton(
            onPressed: () {
              setState(() {});
            },
            child: Text("Grant Camera Permission"),
          ),
        ),
      );
    },
  ),
);
```

# MRZScanner Widget

The `MRZScanner` widget is a Flutter component designed for extracting Machine Readable Zone (MRZ) data from passports and identity cards. This widget utilizes Google ML Kit Text Recognition and an MRZ Parser library to process images captured by the device's camera.

## Usage

```dart
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
  MRZScannerState createState() => MRZScannerState();
}
```

onSuccess: Callback function invoked when MRZ scanning is successful. It provides an MRZResult object and a list of scanned lines.

initialDirection: Initial direction of the camera lens. Defaults to CameraLensDirection.back.

showOverlay: Boolean flag to determine whether to display the scanning overlay. Defaults to true.

resetScanning(): Resets the scanning state.

\_parseScannedText(List<String> lines): Parses the scanned text using the MRZ Parser library.

\_processImage(InputImage inputImage): Processes the input image using the Google ML Kit Text Recognition for MRZ scanning.

# NFC Initialization

The following Flutter code demonstrates how to check for NFC availability and handle the initialization of NFC functionality in a Flutter widget.

## Usage

```dart
Future<void> _initPlatformState() async {
  // Variable to store NFC availability status
  bool isNfcAvailable;

  try {
    // Get the current NFC status from the platform
    NfcStatus status = await NfcProvider.nfcStatus;
    isNfcAvailable = status == NfcStatus.enabled;
  } on PlatformException {
    // An error occurred while checking NFC status, set availability to false
    isNfcAvailable = false;
  }

  // If the widget was removed from the tree while the asynchronous platform
  // message was in flight, discard the reply rather than updating the UI.
  if (!mounted) return;

  // Update the state with the NFC availability status
  _isNfcAvailable = isNfcAvailable;
  setState(() {});

  // Show a Snackbar if NFC is not available
  if (_isNfcAvailable == false) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Couldn't access device NFC, please try again"),
      ),
    );
  }
}
```

The \_initPlatformState method is used to check the availability of NFC on the device.

The NfcProvider.nfcStatus is called to obtain the current status of NFC.

If the status retrieval is successful, the isNfcAvailable variable is set based on whether NFC is enabled.

If there is an exception (e.g., an error during the status check), isNfcAvailable is set to false.

The \_isNfcAvailable state variable is then updated, and the UI is refreshed using setState.

If NFC is not available, a Snackbar is displayed to inform the user.

# MRTD Chip Communication and Data Display Widget

This demonstrates communication with a chip using `dmrtlib` and displays relevant data groups from an MRTD (Machine Readable Travel Document). The widget handles the retrieval and display of user data, image, and signature (if present) from Data Groups 1 (DG1), 2 (DG2), and 7 (DG7) respectively.

## Communication with Chip

Chip communication is facilitated through the `dmrtlib` library. This library enables the widget to interact with the chip to retrieve necessary data from the MRTD and can be see in the `/dmrt_lib` folder

## Displaying Data Groups

Data groups DG1, DG2, and DG7 are displayed conditionally based on their presence in the MRTD data. The remaining data groups are hidden with comments and can be shown by uncommenting the relevant code blocks.

```dart
// Example code for displaying DG1 data
if (_mrtdData?.dg1 != null) {
  list.add(_makeMrtdDataWidget(
      header: 'EF.DG1',
      collapsedText: '',
      dataText: formatDG1(_mrtdData!.dg1!)));
}

// Example code for displaying DG2 data
if (_mrtdData?.dg2 != null) {
  list.add(_makeMrtdDataWidget(
      header: 'EF.DG2',
      collapsedText: '',
      dataText: formatDG2(_mrtdData!.dg2!)));
}

// Example code for displaying DG7 data
if (_mrtdData?.dg7 != null) {
  list.add(_makeMrtdDataWidget(
      header: 'EF.DG7',
      collapsedText: '',
      dataText: formatDG7(_mrtdData!.dg7!)));
}

```

# Note

Data groups that are not displayed by default are commented out. Uncomment the relevant code blocks to display additional data groups as needed.

Feel free to customize and integrate this code into your project based on the specific requirements of your MRTD reading and data display functionalities.

# Image Processing Methods

The following Flutter methods handle image processing, specifically for displaying images in JPG and JPEG2000 formats. These methods are part of a Flutter widget.

## `tryDisplayingJpg()`

This method attempts to display an image in JPG format. If successful, the `jpegImage` state variable is updated, triggering a widget update.

```dart
void tryDisplayingJpg() {
  try {
    // Set the jpegImage state variable with rawImageData
    jpegImage = rawImageData;
    setState(() {});
  } catch (e) {
    // Handle the case when the image is not in JPG format
    jpegImage = null;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image is not in jpg format, trying jpeg2000")));
  }
}
```

## `tryDisplayingJp2()`

This method attempts to display an image in JPEG2000 format. It uses the decodeImage function to process the rawImageData asynchronously. If successful, the jp2000Image state variable is updated, triggering a widget update.

```dart
void tryDisplayingJp2() async {
  try {
    // Decode the rawImageData to get jp2000Image
    jp2000Image = await decodeImage(rawImageData!, context);
    setState(() {});
  } catch (e) {
    // Handle the case when the image is not in JPEG2000 format
    jpegImage = null;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image is not in jpeg2000")));
  }
}

```

## `decodeImage`

This method utilizes a `MethodChannel` named 'image_channel' to invoke a platform-specific method for decoding the provided JPEG2000 image data (`jp2ImageData`). The decoded image data is returned as a `Uint8List`.

```dart
const imageChannel = MethodChannel('image_channel');

Future<Uint8List?> decodeImage(Uint8List jp2ImageData, context) async {
  Uint8List? decodedImageData;

  try {
    // Invoke the platform-specific method for decoding the JPEG2000 image data
    final result = await imageChannel.invokeMethod('decodeImage', {'jp2ImageData': jp2ImageData});

    // Convert the result to Uint8List
    decodedImageData = Uint8List.fromList(result);
  } catch (e) {
    // Handle any errors during the decoding process
    decodedImageData = null;
  }

  return decodedImageData;
}
```

# Image Conversion Handling

The following Flutter code snippet demonstrates the handling of image conversion from Data Group 2 (DG2) in a Flutter widget. By default, the JPG conversion is commented out, and the JPEG2000 conversion is not executed.

```dart

if (mrtdData.dg2?.imageData != null) {

  ........
  // Uncomment the following line to try displaying the image in JPEG2000 format
  tryDisplayingJp2();
}

```

# Android Image Decoding Utility

The following Android code provides an ImageUtil class that handles the decoding of images, specifically supporting JPEG2000 (JP2) format. This class is used in a Flutter project via method channels.

```java

object ImageUtil {

    // Decode JP2 image and send the result back to Flutter
    fun decodeImage(context: Context?, jp2ImageData: ByteArray, result: MethodChannel.Result) {
        // Convert JP2 ByteArray to InputStream
        val inputStream: InputStream = ByteArrayInputStream(jp2ImageData)

        // Use the existing decodeImage function
        val decodedBitmap = decodeImage(context, "image/jp2", inputStream)

        // Convert the Bitmap to a ByteArray for sending back to Flutter
        val byteArrayOutputStream = ByteArrayOutputStream()
        decodedBitmap.compress(Bitmap.CompressFormat.JPEG, 100, byteArrayOutputStream)
        val byteArray = byteArrayOutputStream.toByteArray()

        // Send the decoded image back to Flutter
        result.success(byteArray)
    }

    // Decode image based on MIME type
    fun decodeImage(context: Context?, mimeType: String, inputStream: InputStream?): Bitmap {
        return if (mimeType.equals("image/jp2", ignoreCase = true) || mimeType.equals(
                "image/jpeg2000",
                ignoreCase = true
            )
        ) {
            JP2Decoder(inputStream).decode()
        } else {
            // Add other decoding logic if needed
            BitmapFactory.decodeStream(inputStream)
        }
    }
}
```

## Delay in NFC Scan

To add delay to the nfc scan method you replace ` _readMRTD();` within the `nfc_reader_screen.dart` file: line `704` and adjust the seconds count as required

```dart
Future.delayed(Duration(seconds: 2)).then((value) {
        _readMRTD();
    });

```

Example

```dart

  onPressed: () {
    _initPlatformState();

     Future.delayed(Duration(seconds: 2)).then((value) {
       _readMRTD();
    });
  }

```
