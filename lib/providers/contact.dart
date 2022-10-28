import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Contact with ChangeNotifier {
  dynamic contactid;
  String contact_no;
  String firstname;
  String lastname;
  String email;
  String phone;
  String mobile;
  String mailingstreet;
  String mailingcity;
  String mailingstate;
  String mailingzip;
  String mailingcountry;

  Contact(
      {required this.contactid,
      required this.contact_no,
      required this.firstname,
      required this.lastname,
      required this.email,
      required this.phone,
      required this.mobile,
      required this.mailingcity,
      required this.mailingstreet,
      required this.mailingstate,
      required this.mailingzip,
      required this.mailingcountry});

  var isEmpty = null;
}
