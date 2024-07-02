import 'package:car_find/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _usersCollection =
      _database.collection('users');
  static final User? _currentUser = FirebaseAuth.instance.currentUser;

  static Stream<Profile> getUserProfile() {
    return _usersCollection.doc(currentUser!.uid).snapshots().map((snapshot) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return Profile(
        id: snapshot.id,
        username: data['username'] ?? "",
        email: data['email'] ?? "",
        noTelp: data['noTelp'] ?? "",
      );
    });
  }

  static Future<void> addProfile(
      UserCredential userCredential, Profile profile) async {
    await _usersCollection.doc(userCredential.user!.uid).set({
      "username": profile.username,
      "email": userCredential.user!.email,
      "no_telp": profile.noTelp,
    });
  }

  static User? get currentUser => _currentUser;
}
