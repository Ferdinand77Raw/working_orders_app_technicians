import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Tokens extends ChangeNotifier {
  final String user;
  final String accessKey;

  Tokens({required this.user, required this.accessKey});
}
