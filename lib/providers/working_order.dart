import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WorkingOrder with ChangeNotifier {
  final dynamic workingorderid;
  final dynamic ageminiwo;
  final String workingorder_no;
  final dynamic technician_id;
  final dynamic contact_id;
  final String wostatus;
  final dynamic installtime_start;
  final dynamic installtime_end;
  final DateTime installdateend;

  WorkingOrder({
    required this.workingorderid,
    required this.ageminiwo,
    required this.workingorder_no,
    required this.technician_id,
    required this.contact_id,
    required this.wostatus,
    required this.installtime_start,
    required this.installtime_end,
    required this.installdateend,
  });

  var isEmpty = null;
}
