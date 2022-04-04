import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class JoinService {
  Future joincodelist() async {
    try {
      final CollectionReference collectionReference =
          await FirebaseFirestore.instance.collection('joincode');
      dynamic joincodes =
          await collectionReference.doc('zUQmG1TqHCadvjxTMx31').get();
      dynamic joincodelist = joincodes.data();
      return joincodelist['codes'];
    } on PlatformException catch (e) {
      return null;
    }
  }
}
