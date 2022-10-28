import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:working_orders_app_tablet/providers/auth.dart';
import 'package:working_orders_app_tablet/widgets/app_drawer.dart';
import '../widgets/working_order_grid.dart';

enum FilterOptions { Places, Date }

class UsersScreen extends StatefulWidget {
  static const routeName = '/users-screen';

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _orderByClosestPlace = false;
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
      /*
      Provider.of<Auth>(context).contacts().then((value) {
        setState(() {
          _isLoading = false;
        });
      });*/
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void reload() {
    Provider.of<Auth>(context, listen: false)
        .fetchWorkingOrders()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            ElevatedButton.icon(
                onPressed: reload,
                icon: Icon(Icons.update_rounded),
                label: Text("Reload")),
            PopupMenuButton(
                icon: Icon(Icons.sort_outlined),
                onSelected: (FilterOptions value) {
                  setState(() {
                    if (value == FilterOptions.Places) {
                      _orderByClosestPlace = true;
                    } else {
                      _orderByClosestPlace = false;
                    }
                  });
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text(
                          "Order by closest place",
                          style: TextStyle(fontSize: 20),
                        ),
                        value: FilterOptions.Places,
                      )
                    ]),
          ],
          title: Text(
            'Your Working Orders',
            style: TextStyle(fontSize: 16),
          ),
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : WorkingOrdersGrid(_orderByClosestPlace)
        //WorkingOrdersGrid(_orderByClosestPlace),
        );
  }
}
