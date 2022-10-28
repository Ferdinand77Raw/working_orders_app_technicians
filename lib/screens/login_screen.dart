//import 'dart:math';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:working_orders_app_tablet/providers/auth.dart';
import '../models/http_exceptions.dart';
//import 'package:working_orders_app/providers/working_orders.dart';
//import 'package:working_orders_app/screens/users_screen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login-screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(100, 100, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 250, 200, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      /*transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),*/
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'CRM Working Orders',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 30,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 500 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  //AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'companyName': '',
    'username': '',
    'operation': '',
    'accessKey': ''
  };

  var _isLoading = false;
  //final _accessKeyController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).login(
        _authData['username'] as String,
        _authData['companyName'] as String,
        _authData['operation'] as String,
        _authData['accessKey'] as String,
      );
    } on HttpExceptions catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    /*await Provider.of<WorkingOrders>(context, listen: false)
        .getCompanyName(_authData['companyName'] as String);*/
    setState(() {
      _isLoading = false;
    });
    //Navigator.of(context).pushNamed(SecondLoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: 300,
        constraints: BoxConstraints(minHeight: 260),
        width: deviceSize.width * 1,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      labelText: 'Company Name',
                      labelStyle: TextStyle(fontSize: 20)),
                  keyboardType: TextInputType.text,
                  onSaved: (value) {
                    _authData['companyName'] = value as String;
                  },
                ),
                /*
                TextFormField(
                  decoration: InputDecoration(labelText: 'Access Key'),
                  obscureText: true,
                  controller: _accessKeyController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'This access key is not valid. Try again!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['accessKey'] = value as String;
                  },
                ),*/
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  Padding(
                    padding: EdgeInsets.all(50.0),
                    child: ElevatedButton(
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: _submit,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
