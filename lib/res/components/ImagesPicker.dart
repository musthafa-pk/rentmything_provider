import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';

class ImagesPicker extends StatefulWidget {
  const ImagesPicker({Key? key}) : super(key: key);

  @override
  _ImagesPickerState createState() => _ImagesPickerState();
}

class _ImagesPickerState extends State<ImagesPicker> {
  List<File> _imageFiles = [];

  Future<void> _pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      List<String> selectedFileNames = result.files.map((file) => file.name).toList();
      // Check if any selected file name is already present in _imageFiles
      bool hasDuplicate = selectedFileNames.any((fileName) => _imageFiles.any((file) => file.path.split('/').last == fileName));
      if (hasDuplicate) {
        Fluttertoast.showToast(
          msg: 'File with the same name already selected.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        setState(() {
          _imageFiles.addAll(result.paths.map((path) => File(path!)).toList());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _imageFiles.length <= 5
            ? InkWell(
          onTap: _pickImages,
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color.fromRGBO(7, 59, 76, 0.18),
            ),
            child: const Center(child: Icon(Icons.add, color: Color.fromRGBO(88, 88, 88, 1))),
          ),
        )
            : Text(''),
        const SizedBox(width: 10),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _imageFiles.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Stack(
                  children: [
                    Image.file(
                      _imageFiles[index],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () {
                          setState(() {
                            _imageFiles.removeAt(index);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
