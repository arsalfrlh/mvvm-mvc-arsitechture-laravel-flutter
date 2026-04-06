import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toko/viewmodels/post_viewmodel.dart';
import 'package:toko/views/home_view.dart';

class UploadView extends StatefulWidget {
  const UploadView({super.key});

  @override
  State<UploadView> createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView> {
  final captionController = TextEditingController();
  List<String> imagePaths = [];

  void pickedImage()async{
    final picked = await ImagePicker().pickMultiImage();
    if(picked.isNotEmpty){
      setState(() {
        imagePaths = picked.map((item) => item.path).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final postVM = Provider.of<PostViewmodel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      /// 🔥 APPBAR PREMIUM
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade700, Colors.orange.shade400],
            ),
          ),
        ),
        title: const Text("Buat Postingan",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔥 TYPE DROPDOWN (CARD STYLE)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ],
              ),
            ),

              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: imagePaths.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildAddBox(
                        icon: Icons.add_photo_alternate,
                        label: "Tambah",
                        onTap: pickedImage,
                      );
                    }

                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            File(imagePaths[index - 1]),
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),

                        /// 🔥 DELETE BUTTON
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                imagePaths.removeAt(index - 1);
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

            const SizedBox(height: 20),

            /// 🔥 CAPTION (PREMIUM)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ],
              ),
              child: TextField(
                controller: captionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: "Tulis caption...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// 🔥 BUTTON
            Row(
              children: [

                /// CANCEL
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.orange.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("Batal"),
                  ),
                ),

                const SizedBox(width: 12),

                /// UPLOAD
                Expanded(
                  child: ElevatedButton(
                    onPressed: postVM.isAction
                        ? null
                        : () async {
                            final response = await postVM.addPost(
                              captionController.text,
                              imagePaths
                            );

                            AwesomeDialog(
                              context: context,
                              dialogType: response ? DialogType.success : DialogType.error,
                              title: response ? "Sukses" : "Error",
                              desc: postVM.message,
                              btnOkOnPress: () {
                                if(response){
                                  Navigator.pop(context);
                                }
                              },
                              btnOkColor: response ? Colors.green : Colors.red
                            ).show();
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: Colors.orange.shade700,
                    ),
                    child: postVM.isAction ? const CircularProgressIndicator(color: Colors.white) : const Text("Upload"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// 🔥 COMPONENT ADD BOX (REUSABLE)
  Widget _buildAddBox({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    String? image,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [Colors.orange.shade700, Colors.orange.shade400],
          ),
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(File(image), fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white),
                  const SizedBox(height: 6),
                  Text(label,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 12)),
                ],
              ),
      ),
    );
  }
}