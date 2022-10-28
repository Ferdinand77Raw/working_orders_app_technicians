import 'package:flutter/material.dart';
import 'package:working_orders_app_tablet/providers/auth.dart';
//import 'package:working_orders_app/providers/working_orders.dart';
import 'package:working_orders_app_tablet/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:working_orders_app_tablet/widgets/working_order_grid.dart';
//import 'package:working_orders_app/widgets/working_order_item.dart';

class WorkingOrdersScreen extends StatefulWidget {
  static const routeName = '/working-orders';

  @override
  State<WorkingOrdersScreen> createState() => _WorkingOrdersScreenState();
}

class _WorkingOrdersScreenState extends State<WorkingOrdersScreen> {
  var _orderByPlace = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Auth>(context).fetchWorkingOrders().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    //final WorkOrders = Provider.of<Auth>(context);
    //final workingOrd = WorkOrders.items;
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text('Personal Working Orders'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : WorkingOrdersGrid(_orderByPlace),
    );
  }
}
