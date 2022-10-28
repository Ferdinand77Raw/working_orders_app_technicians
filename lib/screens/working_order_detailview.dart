import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:working_orders_app_tablet/screens/visited_places_detail_screen.dart';
import 'package:working_orders_app_tablet/widgets/visited_places.dart';
import '../providers/auth.dart';

class WorkingOrdersDetailView extends StatelessWidget {
  static const routeName = '/work-order-details';

  @override
  Widget build(BuildContext context) {
    final workOrderId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedWo =
        Provider.of<Auth>(context, listen: false).findWoById(workOrderId);
    return Scaffold(
      appBar: AppBar(
        title: Text("Working Order N°: ${loadedWo.workingorder_no}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "Working Order N°: ${loadedWo.workingorder_no}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 25),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "Agemini Working Order N°: ${loadedWo.ageminiwo}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 25),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "Technician: ${loadedWo.technician_id}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 25),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "Working Order ID: ${loadedWo.workingorderid}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 25),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "Location: ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 25),
              ),
            ),
            Container(
              child: VisitedPlacesDetailScreen(),
              height: 200,
              width: 200,
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
