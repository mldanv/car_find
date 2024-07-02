import 'package:car_find/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:car_find/components/my_text_field.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _tahunController = TextEditingController();
  final TextEditingController _warnaController = TextEditingController();
  final TextEditingController _jalanController = TextEditingController();
  final TextEditingController _kotaController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();
  final TextEditingController _negaraController = TextEditingController();
  final TextEditingController _mapController = TextEditingController();

  // Image yang akan dipilih
  XFile? _imageFile;

  Future<void> _postToFirestore(String? imageUrl) async {
    // Trim seluruh text dari controller
    String nama = _namaController.text.trim();
    String brand = _brandController.text.trim();
    String model = _modelController.text.trim();
    String tahun = _tahunController.text.trim();
    String warna = _warnaController.text.trim();
    String jalan = _jalanController.text.trim();
    String kota = _kotaController.text.trim();
    String noTelp = _noTelpController.text.trim();
    String negara = _negaraController.text.trim();
    String mapUrl = _mapController.text.trim();

    // Cek apakah text field terisi atau tidak
    if (nama.isEmpty ||
        brand.isEmpty ||
        model.isEmpty ||
        tahun.isEmpty ||
        warna.isEmpty ||
        jalan.isEmpty ||
        kota.isEmpty ||
        noTelp.isEmpty ||
        negara.isEmpty ||
        mapUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Semua bagian harus diisi sebelum upload!')),
      );
      return;
    } else {
      try {
        await FirebaseFirestore.instance.collection('cars').add({
          'nama': nama,
          'brand': brand,
          'model': model,
          'tahun': tahun,
          'warna': warna,
          'jalan': jalan,
          'kota': kota,
          'noTelp': noTelp,
          'negara': negara,
          'imageUrl': imageUrl,
          'mapUrl': mapUrl,
          'timestamp': FieldValue.serverTimestamp(),
          'likes': [],
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Berhasil upload!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Gagal post, coba lagi beberapa saat!')),
          );
        }
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                  height: 250,
                  child: _imageFile != null
                      ? Image.network(
                          _imageFile!.path,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.black,
                            ),
                          ),
                          child: const Center(child: Text('No Image')),
                        )),
              //
              //
              const SizedBox(height: 18.0),
              //
              //
              TextButton(
                onPressed: _pickImage,
                child: const Text("Pick Image"),
              ),
              //
              //
              const SizedBox(height: 18.0),
              //
              //
              MyTextField(
                  controller: _namaController,
                  hintText: 'Nama',
                  obscureText: false),
              MyTextField(
                  controller: _brandController,
                  hintText: 'Brand',
                  obscureText: false),
              MyTextField(
                  controller: _modelController,
                  hintText: 'Model',
                  obscureText: false),
              MyTextField(
                  controller: _tahunController,
                  hintText: 'Tahun',
                  obscureText: false),
              MyTextField(
                  controller: _warnaController,
                  hintText: 'Warna',
                  obscureText: false),
              MyTextField(
                  controller: _jalanController,
                  hintText: 'Jalan Dealer',
                  obscureText: false),
              MyTextField(
                  controller: _kotaController,
                  hintText: 'Kota Dealer',
                  obscureText: false),
              MyTextField(
                  controller: _noTelpController,
                  hintText: 'Nomor Telepon',
                  obscureText: false),
              MyTextField(
                  controller: _negaraController,
                  hintText: 'Negara',
                  obscureText: false),
              MyTextField(
                  controller: _mapController,
                  hintText: 'Link Google Map',
                  obscureText: false),
              //
              //
              const SizedBox(height: 64.0),
              //
              //
              ElevatedButton(
                onPressed: () async {
                  String? imageUrl;
                  if (_imageFile != null) {
                    imageUrl = await DatabaseService.uploadImage(_imageFile!);
                  } else {
                    imageUrl = '';
                  }
                  _postToFirestore(imageUrl);
                },
                child: const Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
