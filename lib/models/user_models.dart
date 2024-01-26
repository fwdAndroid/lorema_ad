import 'package:cloud_firestore/cloud_firestore.dart';

class UserModels {
  String uid;
  String name;
  String phoneNumber;
  String photoURL;
  String email;

  UserModels({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.photoURL,
  });

  ///Converting OBject into Json Object
  Map<String, dynamic> toJson() => {
        'name': name,
        'uid': uid,
        'phoneNumber': phoneNumber,
        'email': email,
        'photoURL': photoURL,
      };

  ///
  static UserModels fromSnap(DocumentSnapshot snaps) {
    var snapshot = snaps.data() as Map<String, dynamic>;

    return UserModels(
        email: snapshot['email'],
        photoURL: snapshot['photoURL'],
        name: snapshot['name'],
        uid: snapshot['uid'],
        phoneNumber: snapshot['phoneNumber']);
  }
}
