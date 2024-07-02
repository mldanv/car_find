import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  String? id;
  final String nama;
  final String brand;
  final String model;
  final String tahun;
  final String warna;
  final String jalan;
  final String kota;
  final String noTelp;
  final String negara;
  String? mapUrl;
  String? imageUrl;
  Timestamp? timestamp;
  List<String>? likes;

  Car(
      {this.id,
      required this.nama,
      required this.brand,
      required this.model,
      required this.tahun,
      required this.warna,
      required this.jalan,
      required this.kota,
      required this.noTelp,
      required this.negara,
      this.mapUrl,
      this.likes,
      this.imageUrl,
      this.timestamp});
}
