import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toko/models/barang.dart';
import 'package:toko/viewmodels/barang_viewmodel.dart';

class UpdateView extends StatefulWidget {
  const UpdateView({required this.barang});
  final Barang barang;

  @override
  State<UpdateView> createState() => _UpdateViewState();
}

class _UpdateViewState extends State<UpdateView> {
  late TextEditingController nmBarangController;
  late TextEditingController merkController;
  late TextEditingController stokController;
  late TextEditingController hargaController;
  XFile? gambar;

  @override
  void initState() {
    super.initState();
    nmBarangController = TextEditingController(text: widget.barang.namaBarang);
    merkController = TextEditingController(text: widget.barang.merk);
    stokController = TextEditingController(text: widget.barang.stok.toString());
    hargaController = TextEditingController(text: widget.barang.harga.toString());
  }

  @override
  Widget build(BuildContext context) {
    final barangViewmodel = Provider.of<BarangViewmodel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFF00BF6D),
        foregroundColor: Colors.white,
        title: const Text("Edit Barang"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            ProfilePic(
              image: gambar?.path,
              imageUploadBtnPress: () async{
                final imagePicked = await ImagePicker().pickImage(source: ImageSource.gallery);
                if(imagePicked != null){
                  setState(() {
                    gambar = imagePicked;
                  });
                }
              },
              barang: widget.barang,
            ),
            const Divider(),
            Form(
              child: Column(
                children: [
                  UserInfoEditField(
                    text: "Nama Barang",
                    child: TextFormField(
                      controller: nmBarangController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                  ),
                  UserInfoEditField(
                    text: "Merk",
                    child: TextFormField(
                      controller: merkController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                  ),
                  UserInfoEditField(
                    text: "Stok",
                    child: TextFormField(
                      controller: stokController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                  ),
                  UserInfoEditField(
                    text: "Harga",
                    child: TextFormField(
                      controller: hargaController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.08),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 16.0),
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BF6D),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: barangViewmodel.isLoading
                    ? null
                    : ()async{
                      if(nmBarangController.text.isNotEmpty && merkController.text.isNotEmpty && stokController.text.isNotEmpty && hargaController.text.isNotEmpty){
                        final response = await barangViewmodel.updateBarang(widget.barang.id, gambar?.path, nmBarangController.text, merkController.text, int.parse(stokController.text), int.parse(hargaController.text));
                        AwesomeDialog(
                          context: context,
                          dialogType: response ? DialogType.success : DialogType.error,
                          animType: AnimType.bottomSlide,
                          dismissOnTouchOutside: false,
                          title: response ? "Sukses" : "Error",
                          desc: barangViewmodel.message,
                          btnOkOnPress: (){
                            if(response){
                              Navigator.pop(context);
                            }
                          },
                          btnOkColor: response ? Colors.green : Colors.red
                        ).show();
                      }
                    },
                    child: barangViewmodel.isLoading ? CircularProgressIndicator() : const Text("Save Update"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  ProfilePic({
    this.image,
    required this.imageUploadBtnPress,
    required this.barang
  });

  final String? image;
  final VoidCallback imageUploadBtnPress;
  final Barang barang;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.08),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 50,
            child: image != null ? Image.file(File(image!), width: 80, height: 80,) : CachedNetworkImage(imageUrl: "http://192.168.0.100:8000/storage/images/${barang.gambar}", width: 80, height: 80, fit: BoxFit.cover, errorWidget: (context, url, error) => Icon(Icons.broken_image, size: 80,),),
          ),
          InkWell(
            onTap: imageUploadBtnPress,
            child: CircleAvatar(
              radius: 13,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class UserInfoEditField extends StatelessWidget {
  const UserInfoEditField({
    super.key,
    required this.text,
    required this.child,
  });

  final String text;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0 / 2),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(text),
          ),
          Expanded(
            flex: 3,
            child: child,
          ),
        ],
      ),
    );
  }
}