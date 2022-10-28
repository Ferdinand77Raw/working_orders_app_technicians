import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:working_orders_app_tablet/helpers/location_helper.dart';
import 'package:working_orders_app_tablet/screens/map_screen.dart';

class WorkingOrderLocationInput extends StatefulWidget {
  final Function onSelectPlace;

  WorkingOrderLocationInput(this.onSelectPlace);

  @override
  State<WorkingOrderLocationInput> createState() =>
      _WorkingOrderLocationInputState();
}

class _WorkingOrderLocationInputState extends State<WorkingOrderLocationInput> {
  String? _previewImageUrl;

  void _showPreview(double lat, double long) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: lat, longitude: long);
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreview(locData.latitude as double, locData.longitude as double);
      print(locData.latitude);
      print(locData.longitude);
      widget.onSelectPlace(locData.latitude, locData.altitude);
    } catch (error) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation =
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => MapScreen(
                  isSelecting: true,
                )));
    if (selectedLocation == null) {
      return;
    }
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 200,
            width: double.infinity,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
            child: _previewImageUrl == null
                ? Text(
                    "No location Chosen",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  )
                : Image.network(
                    _previewImageUrl as String,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
                onPressed: _getCurrentUserLocation,
                icon: Icon(Icons.location_on),
                label: Text(
                  "Current location",
                  style: TextStyle(fontSize: 20),
                )),
            TextButton.icon(
                onPressed: _selectOnMap,
                icon: Icon(Icons.map),
                label: Text(
                  "Select on Map",
                  style: TextStyle(fontSize: 20),
                )),
          ],
        )
      ],
    );
  }

  void didChangeDependencies() {
    _getCurrentUserLocation();

    super.didChangeDependencies();
  }
}
