import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:working_orders_app_tablet/models/http_exceptions.dart';
import 'package:working_orders_app_tablet/providers/auth.dart';
import 'package:working_orders_app_tablet/screens/visited_places_detail_screen.dart';
import 'package:working_orders_app_tablet/widgets/app_drawer.dart';
import './working_orders_locations.dart';
//import '../providers/great_places.dart';

class VisitedPlacesListScreen extends StatelessWidget {
  static const routeName = 'PlacesListScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(WorkingOrdersLocationsScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Auth>(context, listen: false).fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<Auth>(
                child: Center(
                  child: const Text('Got no places yet, start adding some!'),
                ),
                builder: (context, greatPlaces, index) =>
                    greatPlaces.items.length <= 0
                        ? Text("No places added")
                        : ListView.builder(
                            itemCount: greatPlaces.items.length,
                            itemBuilder: (ctx, index) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage: FileImage(
                                  greatPlaces.items[index].image,
                                ),
                              ),
                              title: Text(greatPlaces.items[index].title),
                              subtitle: Text(
                                  greatPlaces.items[index].location.address),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  VisitedPlacesDetailScreen.routeName,
                                  arguments: greatPlaces.items[index].id,
                                );
                              },
                            ),
                          ),
              ),
      ),
    );
  }
}
