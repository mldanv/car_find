import 'package:car_find/components/like_button.dart';
import 'package:car_find/models/car.dart';
import 'package:car_find/models/comment.dart';
import 'package:car_find/services/comment_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final Car car;
  const DetailScreen({super.key, required this.car});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  static final CollectionReference _carsCollection =
      FirebaseFirestore.instance.collection('cars');
  bool isLiked = false;

  // Jika user email dalam list likes car
  @override
  void initState() {
    super.initState();
    isLiked = widget.car.likes!.contains(currentUser.email);
  }

  void addLike(String? userEmail) {
    setState(() {
      if (widget.car.likes!.contains(userEmail)) {
        widget.car.likes!.remove(userEmail);
      } else {
        widget.car.likes!.add(userEmail!);
      }
    });
  }

  void toggleLike() async {
    addLike(currentUser.email);
    setState(() {
      isLiked = !isLiked;
    });

    Map<String, dynamic> updatedLikes = {
      'likes': widget.car.likes,
    };

    try {
      await _carsCollection.doc(widget.car.id).update(updatedLikes);
    } catch (e) {
      print('Error updating likes: $e');
      setState(() {
        addLike(currentUser.email);
      });
    }
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DISCOVERY'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.nama,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 28.0),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 24.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 10),
                        borderRadius: BorderRadius.circular(20.0)),
                    width: double.infinity,
                    child: (car.imageUrl != null &&
                            Uri.parse(car.imageUrl!).isAbsolute
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(
                              car.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container()),
                  ),
                ],
              ),
            ),
            //
            Container(
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.secondary),
              padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      LikeButton(
                        isLiked: isLiked,
                        onTap: toggleLike,
                      ),
                      IconButton(
                          onPressed: commentDialog,
                          icon: const Icon(
                            Icons.comment,
                            color: Colors.white,
                          ))
                    ],
                  ),
                  const Text('SPESIFIKASI'),
                  Row(
                    children: [const Text('Brand :'), Text(car.brand)],
                  ),
                  Row(
                    children: [const Text('Model :'), Text(car.model)],
                  ),
                  Row(
                    children: [const Text('Tahun :'), Text(car.tahun)],
                  ),
                  Row(
                    children: [const Text('Warna :'), Text(car.warna)],
                  ),
                ],
              ),
            ),
            //
            // Dealer
            //
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DEALER TERSEDIA',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 24.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 10),
                        borderRadius: BorderRadius.circular(20.0)),
                    width: double.infinity,
                    child: (car.imageUrl != null &&
                            Uri.parse(car.imageUrl!).isAbsolute
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(
                              car.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container()),
                  ),
                ],
              ),
            ),
            Container(
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.secondary),
              padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
              child: Column(
                children: [
                  Text(
                    'LOKASI',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (car.mapUrl != null) {
                        Uri url = Uri.parse(car.mapUrl!);
                        _launchUrl(url);
                      }
                    },
                    child: const Text(
                      'Buka dengan Map',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                  Row(
                    children: [const Text('Jalan :'), Text(car.jalan)],
                  ),
                  Row(
                    children: [const Text('Kota :'), Text(car.kota)],
                  ),
                  Row(
                    children: [const Text('No. Telp :'), Text(car.noTelp)],
                  ),
                  Row(
                    children: [const Text('Negara :'), Text(car.negara)],
                  ),
                ],
              ),
            ),
            const Center(child: Text("Komentar")),
            SizedBox(
              height: 300,
              child: StreamBuilder<List<Comment>>(
                stream: CommentService.getComments(car),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                        children: snapshot.data!.map((document) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 4.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          width: 350,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircleAvatar(
                                radius: 12.0,
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Icons.person,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 4.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(document.userId),
                                    Text(document.pesan),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error${snapshot.error}'));
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> commentDialog() async {
    String pesan = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          "Tambah Komentar",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Masukkan Komentar',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            pesan = value;
          },
        ),
        actions: [
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(pesan),
          )
        ],
      ),
    );

    if (pesan.trim().isNotEmpty) {
      //only update if there is something on the field
      await CommentService.addComment(widget.car.id!, pesan);
    }
  }
}
