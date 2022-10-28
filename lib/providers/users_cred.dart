import 'package:flutter/cupertino.dart';

class UserCredentials with ChangeNotifier {
  final dynamic user_id;
  final String user_name;
  final String user_password;

  UserCredentials(
      {required this.user_id,
      required this.user_name,
      required this.user_password});
}
