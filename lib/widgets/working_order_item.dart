import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:working_orders_app_tablet/providers/working_orders.dart';
import 'package:intl/intl.dart';
import 'package:working_orders_app_tablet/screens/working_orders_locations.dart';
//import 'package:working_orders_app_tablet/screens/working_order_detailview.dart';

class WorkingOrderItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workingOrders = Provider.of<WorkingOrders>(context);

    var mailingStreet = workingOrders.mailingstreet;
    var mailingCity = workingOrders.mailingcity;
    var mailingState = workingOrders.mailingstate;
    var mailingZip = workingOrders.mailingzip;
    var mailingCountry = workingOrders.mailingcountry;
    var comma = " ,";
    List joinedAddressData = [
      mailingStreet,
      comma,
      mailingCity,
      comma,
      mailingState,
      comma,
      mailingZip,
      comma,
      mailingCountry
    ];
    String completeAddress = joinedAddressData.join();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Working Order N°: ${workingOrders.workingorder_no}",
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Agemini Working Order: ${workingOrders.ageminiwo}",
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Status: ${workingOrders.wostatus}",
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Contact Name: ${workingOrders.firstname}",
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onBackground)),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Contact Last Name: ${workingOrders.lastname}",
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onBackground)),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Install date end: " +
                        DateFormat.yMMMEd()
                            .format(workingOrders.installdateend),
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                        "Install time start: ${workingOrders.installtime_start}",
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onBackground)),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                        "Install time end: ${workingOrders.installtime_end}",
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onBackground)),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                      child: Text(
                        "Address: ${completeAddress}",
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(WorkingOrdersLocationsScreen.routeName);
                        print("Button pressed");
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
