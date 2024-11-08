import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_realproject/model/user.dart';
import 'package:el_realproject/model/report.dart';
import 'package:el_realproject/screens/reports/reports.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ required this.uid });

  // user collection reference
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  // reports collection reference
  final CollectionReference reportsCollection = FirebaseFirestore.instance.collection('reports');

  //add or set user data
  Future<void> setUserData(UserDetails userDetails) async {
    return await usersCollection.doc(uid).set({
      'address': userDetails.address,
      'username': userDetails.username,
      'phoneNumber': userDetails.phoneNumber,
      'icNumber': userDetails.icNumber,
      'imageUrl': userDetails.imageUrl,
    });
  }

  //add report
  Future<DocumentReference<Object?>> addReport(Report report) async {
    return await reportsCollection.add({
      'uid': uid,
      'description': report.description,
      'imageUrl': report.imageUrl,
      'dateTime': report.dateTime,
      'reference': report.reference,
      'location': report.location,
      'status': report.status,
    });
  }

  //get user extra info
  Stream<DocumentSnapshot<Object?>> getUserDetails()  {
    return usersCollection
        .doc(uid)
        .snapshots();
  }

  //get reports based on status and id
  Stream<QuerySnapshot<Object?>> getReports(Status status)  {
    return reportsCollection
        .where("uid", isEqualTo: uid)
        .where("status", isEqualTo: status.name)

        .snapshots();
  }

}