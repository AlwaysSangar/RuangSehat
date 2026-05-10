import 'package:flutter/material.dart';
import 'dart:io';

class ImageInput extends StatelessWidget {
  final VoidCallback onTap; // menerima fungsi dari luar
  final String? imagePath; // untuk menampilkan gambar jika sudah dipilih
  
  const ImageInput ({super.key, required this.onTap, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.width / 2,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          image: imagePath != null
            ? DecorationImage(
                image: FileImage(
                  File(imagePath!), // perlu import dart:io
                ),
                fit: BoxFit.cover
              )
            :null
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath == null) ...[
              Text(
                'Drop file here of browse',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "pdf, docx, png",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              )
            ]
          ],
        ),
      )
    );
  }
}