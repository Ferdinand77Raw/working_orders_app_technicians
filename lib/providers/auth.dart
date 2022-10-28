import 'package:flutter/widgets.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:working_orders_app_tablet/providers/working_orders.dart';
import 'dart:convert';
import '../models/http_exceptions.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'tokens.dart';
import 'package:working_orders_app_tablet/providers/working_order.dart';
import 'package:working_orders_app_tablet/providers/users_cred.dart';
import 'package:working_orders_app_tablet/providers/contact.dart';
import 'dart:developer';
import 'package:working_orders_app_tablet/models/place.dart';
import 'package:intl/intl.dart';
import 'package:dbcrypt/dbcrypt.dart';
import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';

class Auth with ChangeNotifier {
  Auth(this._sessionId);

  String _sessionId;
  String? _companyName;
  String? _userId;
  String? _userName;
  DateTime? _expireDate;
  Timer? _authTimer;
  String? _types;
  String? _user_name;
  String? _user_password;
  String? _id;
  String? _authUserName;
  String? _contactId;
  String? _wContactId;
  String? _contactName;
  String? _mailingstreet;
  String? _mailingcity;
  String? _mailingstate;
  String? _mailingzip;
  String? _mailingcountry;

  bool get isAuth {
    return sessionId != null;
  }

  String? get sessionId {
    if (_expireDate != null &&
        _expireDate!.isAfter(DateTime.now()) &&
        _sessionId != null) {
      return _sessionId;
    }
    return null;
  }

  String? get sessionIdForTypes {
    return _sessionId;
  }

  String? get userId {
    return _userId;
  }

  String? get companyName {
    return _companyName;
  }

  String? get username {
    return _userName;
  }

  String? get types {
    return _types;
  }

  String? get user_name {
    return _user_name;
  }

  String? get user_password {
    return _user_password;
  }

  String? get id {
    return _id;
  }

  String? get authUserName {
    return _authUserName;
  }

  String? get contactId {
    return _contactId;
  }

  String? get wContactId {
    return _wContactId;
  }

  String? get contactName {
    return _contactName;
  }

  String? get mailingstreet {
    return _mailingstreet;
  }

  String? get mailingcity {
    return _mailingcity;
  }

  String? get mailingstate {
    return _mailingstate;
  }

  String? get mailingzip {
    return _mailingzip;
  }

  String? get mailingcountry {
    return _mailingcountry;
  }

  List<UserCredentials> _userCred = [];

  List<UserCredentials> get userCred {
    return [..._userCred];
  }

  List<Contact> _contactItems = [];

  List<Contact> get contactItems {
    return [..._contactItems];
  }

  List<WorkingOrder> _workingOrderItems = [];

  List<WorkingOrder> get workingOrderItems {
    return [..._workingOrderItems];
  }

  List<WorkingOrders> _nWorkingOrderItems = [];

  List<WorkingOrders> get nWorkingOrderItems {
    return [..._nWorkingOrderItems];
  }

  List<Place> _placesItems = [];

  List<Place> get items {
    return [..._placesItems];
  }

  Future<void> _authenticate(String username, String companyName,
      String operation, String accessKey) async {
    final url = Uri.parse(
        'https://$companyName.mycrmllc.com/webservice.php?operation=getchallenge&username=$username');
    final loginUrl =
        Uri.parse('https://$companyName.mycrmllc.com/webservice.php');

    _companyName = companyName;
    try {
      var firstResponse = await http.get(url);

      var firstResponseData = json.decode(firstResponse.body);
      var expectedToken = firstResponseData['result']['token'];
      String convertedToken = expectedToken.toString();
      //print(expectedToken);

      var user = Uri.parse('$username');
      var access = Uri.parse('$accessKey');

      var convertedUser = user.toString();
      var convertedAcc = access.toString();
      var operation = 'login';
      List md5Splitted = [convertedToken, convertedAcc];
      String md5Tkn = md5Splitted.join();
      var bytesToHash = utf8.encode(md5Tkn);
      var md5Digest = md5.convert(bytesToHash);

      if (firstResponse.statusCode == 200) {
        //print('MD5: $md5Digest');

        var response = await http.post(loginUrl,
            body: ({
              'operation': operation,
              'username': convertedUser,
              'accessKey': '$md5Digest'
            }));

        var responseData = json.decode(response.body);

        if (responseData == ['error']) {
          throw HttpExceptions(responseData['error']['message']);
        } else {
          print(responseData);
        }

        _sessionId = responseData['result']['sessionName'];
        _userId = responseData['result']['userId'];
        _expireDate = DateTime.now().add(Duration(
            seconds:
                int.parse(responseData['result']['other_event_duration'])));
        _companyName = companyName;
        //_userName = responseData['result']['username'];
        /**This function is in charge of auto logout when token expires. Even though it works, 
         * it's not a friendly approach.
        */
        /*
        void _autoLogout() {
          if (_authTimer != null) {
            _authTimer!.cancel();
          }
          final timeToExpire =
              _expireDate!.difference(DateTime.now()).inSeconds;
          _authTimer = Timer(Duration(seconds: timeToExpire), logout);
        }
        _autoLogout();*/
      }
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'sessionId': _sessionId,
          'userId': _userId,
          'expireDate': _expireDate!.toIso8601String()
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchUsers() async {
    var uquery = "SELECT user_name, user_password FROM Users;";
    final retrieveUrl = Uri.parse(
        "https://$companyName.mycrmllc.com/webservice.php?operation=query&sessionName=$sessionIdForTypes&query=$uquery");
    final retrieveResponse = await http.get(retrieveUrl);
    final extractedUser =
        json.decode(retrieveResponse.body) as Map<String, dynamic>;
    //print(extractedUser);
    final extU = extractedUser['result'];
    final List<UserCredentials> userCred = [];
    extU.forEach((value) {
      userCred.add(UserCredentials(
          user_id: value['id'],
          user_name: value['user_name'],
          user_password: value['user_password']));
    });
    _userCred = userCred.toList();
    notifyListeners();
  }
  /*
  Future<void> contacts() async {
    final cquery = "SELECT * FROM Contacts;";
    final retrieveFirstUrl = Uri.parse(
        "https://$companyName.mycrmllc.com/webservice.php?operation=query&sessionName=$sessionIdForTypes&query=$cquery");
    final firstResponse = await http.get(retrieveFirstUrl);
    final extractedContact =
        json.decode(firstResponse.body) as Map<String, dynamic>;
    final extC = extractedContact['result'];
    final List<Contact> contacts = [];
    extC.forEach((value) {
      contacts.add(Contact(
        contactid: value['id'],
        contact_no: value['contact_no'],
        firstname: value['firstname'],
        lastname: value['lastname'],
        email: value['email'],
        phone: value['phone'],
        mobile: value['mobile'],
        mailingstreet: value['mailingstreet'],
        mailingcity: value['mailingcity'],
        mailingcountry: value['mailingcountry'],
        mailingzip: value['mailingzip'],
        mailingstate: value['mailingstate'],
      ));
      var street = value['mailingstreet'];
      var city = value['mailingcity'];
      var state = value['mailingstate'];
      var zip = value['mailingzip'];
      var country = value['mailingcountry'];

      var contact_id = value['id'];

      _mailingstreet = street;
      _mailingcity = city;
      _mailingstate = state;
      _mailingzip = zip;
      _mailingcountry = country;
      _contactId = contact_id;
    });

    _contactItems = contacts.toList();
    notifyListeners();
  }*/

  Future<void> _loginUser(String username, String userpassword) async {
    var uquery =
        "SELECT user_password FROM Users WHERE user_name = '$username';";
    final retrieveFirstUrl = Uri.parse(
        "https://$companyName.mycrmllc.com/webservice.php?operation=query&sessionName=$sessionIdForTypes&query=$uquery");
    final firstResponse = await http.get(retrieveFirstUrl);
    final extractedHash = json.decode(firstResponse.body);
    final extP = extractedHash['result'][0]['user_password'];
    //print("The hash is " + extP.toString());
    DBCrypt dbCrypt = DBCrypt();

    var isCorrect = dbCrypt.checkpw(userpassword, extP);

    _authUserName = username;
    if (isCorrect == true) {
      var pquery =
          "SELECT * FROM Users WHERE user_name='$username' AND user_password='$extP';";
      final retrieveUrl = Uri.parse(
          "https://$companyName.mycrmllc.com/webservice.php?operation=query&sessionName=$sessionIdForTypes&query=$pquery");
      final retrieveResponse = await http.get(retrieveUrl);
      final extractedData =
          json.decode(retrieveResponse.body) as Map<String, dynamic>;
      final extU = extractedData['result'];
      //print(extU);

      final List<UserCredentials> userCred = [];
      extU.forEach((value) {
        userCred.add(UserCredentials(
            user_id: value['id'],
            user_name: value['user_name'],
            user_password: value['user_password']));
        _id = value['id'];
        print("El usuario logueado tiene id: ${_id}");
      });
      _userCred = userCred.toList();
    } else {
      throw HttpExceptions("The credentials are incorrect!");
    }

    notifyListeners();
  }

  Future<void> fetchWorkingOrders() async {
    var fquery = "SELECT * FROM WorkingOrder WHERE technician_id=${_id};";
    final retrieveUrl = Uri.parse(
        "https://$companyName.mycrmllc.com/webservice.php?operation=query&sessionName=$sessionIdForTypes&query=$fquery");
    final retrieveResponse = await http.get(retrieveUrl);
    final extractedWo =
        json.decode(retrieveResponse.body) as Map<String, dynamic>;
    final extW = extractedWo['result'];
    final List<WorkingOrder> workingOrders = [];
    extW.forEach((value) async {
      workingOrders.add(WorkingOrder(
        workingorderid: value['id'] as dynamic,
        ageminiwo: value['ageminiwo'] as dynamic,
        workingorder_no: value['workingorder_no'],
        technician_id: value['technician_id'] as dynamic,
        contact_id: value['contactid'],
        wostatus: value['wostatus'],
        installtime_start: value['installtime_start'] as dynamic,
        installtime_end: value['installtime_end'] as dynamic,
        installdateend: DateTime.parse(value['installdateend']),
      ));
    });

    print(extractedWo);
    //_workingOrderItems = workingOrders.toList();

    for (var i = 0; i < workingOrders.length; i++) {
      var wi = extW[i]['id'];
      var wno = extW[i]['workingorder_no'];
      var w = extW[i]['technician_id'];
      var a = extW[i]['ageminiwo'];
      var st = extW[i]['wostatus'];
      var c = extW[i]['contactid'];
      var it_s = extW[i]['installtime_start'];
      var it_e = extW[i]['installtime_end'];
      var itde = extW[i]['installdateend'];

      //var getId = c;
      var newQuery =
          "SELECT firstname, lastname, mailingstreet, mailingcity, mailingstate, mailingzip, mailingcountry FROM Contacts WHERE id=${c};";
      final retrieveData = Uri.parse(
          "https://$companyName.mycrmllc.com/webservice.php?operation=query&sessionName=$sessionIdForTypes&query=$newQuery");
      final req = await http.get(retrieveData);
      final ext = json.decode(req.body) as Map<String, dynamic>;
      final extnW = ext['result'];
      //print(extnW);
      List<WorkingOrders> workingOrders = [];
      extnW.forEach((value) {
        workingOrders.add(WorkingOrders(
          workingorderid: wi,
          ageminiwo: a,
          workingorder_no: wno,
          technician_id: w,
          contact_id: c,
          wostatus: st,
          installtime_start: it_s,
          installtime_end: it_e,
          installdateend: DateTime.parse(itde),
          firstname: value['firstname'],
          lastname: value['lastname'],
          mailingstreet: value['mailingstreet'],
          mailingcity: value['mailingcity'],
          mailingstate: value['mailingstate'],
          mailingzip: value['mailingzip'],
          mailingcountry: value['mailingcountry'],
        ));

        notifyListeners();
        _nWorkingOrderItems = workingOrders.toList();
      });
    }
  }

  WorkingOrder findWoById(workOrderId) {
    var fquery = "SELECT * FROM WorkingOrder;";
    final retrieveUrl = Uri.parse(
        "https://$companyName.mycrmllc.com/webservice.php?operation=query&sessionName=$sessionIdForTypes&query=$fquery");
    http.get(retrieveUrl);
    return _workingOrderItems
        .firstWhere((element) => element.workingorder_no == workOrderId);
  }

  Future<void> login(String username, String companyName, String operation,
      String accessKey) async {
    return _authenticate(username, companyName, operation, accessKey);
  }

  Future<void> loginUser(String username, String userpassword) async {
    return _loginUser(username, userpassword);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = prefs.getString('userData');
    final userData = json.decode(extractedUserData!) as Map<String, dynamic>;
    final expireDate = DateTime.parse(userData['expireDate'] as String);

    if (expireDate.isAfter(DateTime.now())) {
      return false;
    }
    _sessionId = userData['sessionId'] as String;
    _userId = userData['userId'] as String;
    _expireDate = expireDate;

    return true;
  }

  Place findById(String id) {
    return _placesItems.firstWhere((place) => place.id == id);
  }

  /**Cuando apriete en el add place o save visit, que cambie el status de la working order a completed */
  Future<void> addPlace(
    String pickedTitle,
    File pickedImage,
    PlaceLocation pickedLocation,
  ) async {
    final address = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    final updatedLocation = PlaceLocation(
      latitude: pickedLocation.latitude,
      longitude: pickedLocation.longitude,
      address: address,
    );
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: pickedImage,
      title: pickedTitle,
      location: updatedLocation,
    );
    _placesItems.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _placesItems = dataList
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            image: File(item['image']),
            location: PlaceLocation(
              latitude: item['loc_lat'],
              longitude: item['loc_lng'],
              address: item['address'],
            ),
          ),
        )
        .toList();
    notifyListeners();
  }

  void logout() {
    _sessionId = '';
    _userId = '';
    _expireDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }
}
