import 'dart:io';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:working_orders_app_tablet/providers/auth.dart';
//import 'package:working_orders_app_tablet/providers/great_places.dart';
import 'package:working_orders_app_tablet/models/place.dart';
import 'package:flutter/material.dart';
import 'package:working_orders_app_tablet/widgets/app_drawer.dart';
//import 'package:working_orders_app_tablet/widgets/signature_input.dart';
import 'package:working_orders_app_tablet/widgets/working_orders_location_input.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:image_picker/image_picker.dart';

//import 'package:geocoder/geocoder.dart';
class WorkingOrdersLocationsScreen extends StatefulWidget {
  static const routeName = '/working-order-locations-screen';

  @override
  _WorkingOrdersLocationsState createState() => _WorkingOrdersLocationsState();
}

class _WorkingOrdersLocationsState extends State<WorkingOrdersLocationsScreen> {
  String path = '/storage/emulated/0/flutterfumes';

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

  final _titleController = TextEditingController();
  File? _pickedImage;
  PlaceLocation? _pickedLocation;

  SignatureController _controller = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.blue);

  _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng, address: "");
  }

  void _savePlace() {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null) {
      return;
    }
    Provider.of<Auth>(context, listen: false).addPlace(
        _titleController.text, _pickedImage as File, _pickedLocation!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [BackButton()],
        title: Text(
          'Working Order',
          style: TextStyle(fontSize: 20),
        ),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 650,
              width: double.infinity,
              //child: Expanded(
              child: SingleChildScrollView(
                //child: Padding(
                //padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    /**Aqui debe ir el nombre de la working order */
                    /*
                    TextField(
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                    ),*/
                    Signature(
                      controller: _controller,
                      height: 500,
                      backgroundColor: Colors.blue,
                    ),
                    //VisitedPlaces(_selectImage),
                    //SignatureInput(),
                    SizedBox(
                      height: 25,
                    ),
                    /**Aqui en esta logica debería poder mandarse la dirección de la working
                       * order para que se ajuste en el mapita
                       */
                    WorkingOrderLocationInput(_selectPlace),
                  ],
                ),
              ),
            ),
            //),
            /*
            ElevatedButton(
              child: Text(
                'Save visit',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: _savePlace,
            ),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*
                IconButton(
                    onPressed: () async {
                      _savePlace;
                      if (_controller.isNotEmpty) {
                        var data = await _controller.toPngBytes();

                        
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          var name = Provider.of<Auth>(context);
                          return Scaffold(
                            body: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    color: Colors.blue,
                                    child: Image.memory(data!),
                                  ),
                                  Text("Image saved in ${name.user_name}")
                                ],
                              ),
                            ),
                          );
                        }));
                      }
                    },
                    icon: Icon(Icons.check)),*/
                IconButton(
                  onPressed: () async {
                    if (_controller.isNotEmpty) {
                      var data = await _controller.toPngBytes();

                      if (await Permission.storage.request().isGranted) {
                        // Either the permission was already granted before or the user just granted it.

                        await _createFile(data);

                        Fluttertoast.showToast(msg: 'Signature Saved...');
                      }
                    }
                  },
                  icon: Icon(Icons.save),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _controller.clear();
                      });
                    },
                    icon: Icon(Icons.clear)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
