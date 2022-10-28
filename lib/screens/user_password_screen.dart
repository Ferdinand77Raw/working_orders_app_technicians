import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:working_orders_app_tablet/models/http_exceptions.dart';
import 'package:working_orders_app_tablet/screens/users_screen.dart';
import '../providers/auth.dart';

//enum AuthMode { Signup, Login }

class UserPasswordScreen extends StatefulWidget {
  static const routeName = '/user-password';
  @override
  State<UserPasswordScreen> createState() => _UserPasswordScreenState();
}

class _UserPasswordScreenState extends State<UserPasswordScreen> {
  //var _isInit = true;
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(children: [
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
                  flex: deviceSize.width > 700 ? 2 : 1,
                  child: UserCard(),
                ),
              ]),
        ),
      )
    ]));
  }
}

class UserCard extends StatefulWidget {
  const UserCard({
    Key? key,
  }) : super(key: key);
  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  //AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'user_name': '',
    'user_password': '',
  };

  var _isLoading = false;
  final _accessKeyController = TextEditingController();

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
      await Provider.of<Auth>(context, listen: false).loginUser(
        _authData['user_name'] as String,
        _authData['user_password'] as String,
      );
      Navigator.of(context).pushNamed(UsersScreen.routeName);
    } on HttpExceptions catch (error) {
      var errorMessage = 'Authentication failed! Credentials are not correct!';
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
    setState(() {
      _isLoading = false;
    });
  }

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
        padding: EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(fontSize: 20)),
                  keyboardType: TextInputType.text,
                  onSaved: (value) {
                    _authData['user_name'] = value as String;
                  },
                ),
                TextFormField(
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 20)),
                  obscureText: true,
                  controller: _accessKeyController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'This password is not valid. Try again!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['user_password'] = value as String;
                  },
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: ElevatedButton(
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: _submit,
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
