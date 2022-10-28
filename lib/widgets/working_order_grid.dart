import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:working_orders_app_tablet/providers/auth.dart';
import './working_order_item.dart';

class WorkingOrdersGrid extends StatelessWidget {
  final bool orderByPlace;
  WorkingOrdersGrid(this.orderByPlace);
  @override
  Widget build(BuildContext context) {
    final WorkOrdersData = Provider.of<Auth>(context);
    final workOrders = WorkOrdersData.nWorkingOrderItems;

    final deviceSize = MediaQuery.of(context).size;
    return Container(
        height: deviceSize.height,
        child: workOrders.isEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No working orders for you at the moment',
                    style: TextStyle(fontSize: 35),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    height: 200,
                    child: Image.asset(
                      'assets/images/restman.png',
                      fit: BoxFit.contain,
                    ),
                    alignment: Alignment.center,
                  )
                ],
              )
            : ListView.builder(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(10.0),
                itemCount: workOrders.length,
                itemBuilder: (context, int index) =>
                    ChangeNotifierProvider.value(
                  value: workOrders[index],
                  child: WorkingOrderItem(),
                ),
              ));
  }
}
