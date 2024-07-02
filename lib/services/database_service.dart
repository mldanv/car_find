import 'dart:io' as io;
import 'package:car_find/models/car.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _carCollection =
      _database.collection('cars');
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final currentUser = FirebaseAuth.instance.currentUser;

  static Future<String?> uploadImage(XFile file) async {
    try {
      String fileName = path.basename(file.path);
      Reference ref = _storage.ref().child('images').child('/$fileName');
      UploadTask uploadTask;

      if (kIsWeb) {
        uploadTask = ref.putData(await file.readAsBytes());
      } else {
        uploadTask = ref.putFile(io.File(file.path));
      }

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  static Stream<List<Car>> getCarList() {
    return _carCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Car(
            id: doc.id,
            nama: data['nama'],
            brand: data['brand'],
            model: data['model'],
            tahun: data['tahun'],
            warna: data['warna'],
            jalan: data['jalan'],
            kota: data['kota'],
            noTelp: data['noTelp'],
            negara: data['negara'],
            mapUrl: data['mapUrl'],
            imageUrl: data['imageUrl'],
            timestamp: data['timestamp'],
            likes: List<String>.from(data['likes'] ?? []));
      }).toList();
    });
  }

  static Stream<List<Car>> getFavoriteCarList() {
    return _carCollection
        .where('likes', arrayContains: currentUser!.email)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Car(
            id: doc.id,
            nama: data['nama'],
            brand: data['brand'],
            model: data['model'],
            tahun: data['tahun'],
            warna: data['warna'],
            jalan: data['jalan'],
            kota: data['kota'],
            noTelp: data['noTelp'],
            negara: data['negara'],
            imageUrl: data['imageUrl'],
            timestamp: data['timestamp'],
            likes: List<String>.from(data['likes'] ?? []));
      }).toList();
    });
  }
}
