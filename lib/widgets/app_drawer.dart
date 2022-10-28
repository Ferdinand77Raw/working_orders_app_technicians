import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:working_orders_app_tablet/screens/users_screen.dart';
import 'package:working_orders_app_tablet/screens/visited_places_list.screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = Provider.of<Auth>(context);
    return Drawer(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            DrawerHeader(
                child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Icon(
                Icons.person_rounded,
                size: 80,
              ),
            )),
            Text(
              "Hello ${name.authUserName}",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 40,
            ),
            ListTile(
              leading: Icon(Icons.house),
              title: Text('Home'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UsersScreen.routeName);
              },
            ),
            SizedBox(
              height: 30,
            ),
            ListTile(
                leading: Icon(Icons.location_city_outlined),
                title: Text('Search Visited Places'),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(VisitedPlacesListScreen.routeName);
                }),
            SizedBox(
              height: 30,
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
            Padding(
              padding: EdgeInsets.all(80.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(500),
                splashColor: Colors.black45,
                onTap: (() {
                  Navigator.of(context).pop();
                }),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
