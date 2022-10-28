//import 'dart:html';
//import 'dart:typed_data';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:signature/signature.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:working_orders_app_tablet/screens/users_screen.dart';

class SignatureInput extends StatefulWidget {
  @override
  State<SignatureInput> createState() => _SignatureInputState();
}

class _SignatureInputState extends State<SignatureInput> {
  String path = '/storage/emulated/0/flutterfumes';

  SignatureController _controller = SignatureController(
      penStrokeWidth: 1,
      penColor: Colors.black,
      exportBackgroundColor: Colors.blue);
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      print("Value changed");
    });
  }

  Future<void> writeTofile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<void> _createFile(var data) async {
    Uint8List bytes = data;
    final result = await ImageGallerySaver.saveImage(bytes);
    print(result);
    return result;
  }

  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _controller.clear();
                  });
                },
                icon: Icon(Icons.clear)),
            IconButton(
              onPressed: () async {
                if (_controller.isNotEmpty) {
                  var data = await _controller.toPngBytes();

                  if (await Permission.storage.request().isGranted) {
                    // Either the permission was already granted before or the user just granted it.

                    await _createFile(data);

                    Fluttertoast.showToast(
                        msg: 'Signature Saved...', fontSize: 30);
                  }
                }
              },
              icon: Icon(Icons.save),
            ),
          ]),
    );
  }
}
