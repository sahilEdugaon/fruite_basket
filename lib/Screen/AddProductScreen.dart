import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ProductListScreen.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String? _category; // Initialize as reactive
  File? _image;
  bool uploading = false;
  final _formKey = GlobalKey<FormState>();
  String? downloadUrl;
  String? fileName;
  List<String> selectedFileNames = [];


  // final List<String> categories = ['Apple', 'Clothing', 'Food', 'Books']; // Example categories
  final Map<String, String> categories = {
    'apple':'Apple',
    'grapes':'Grapes',
    'mango':'Mango',
    'orange':'Orange',
  }; // Example categories

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    String timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

    uploading = true;
    if (pickedFile != null) {

         fileName = pickedFile.path.split('/').last;
        selectedFileNames.add(fileName??"");
         setState(() {
           _image = File(pickedFile.path);
         });
        try {
          final storageRef = FirebaseStorage.instance.ref().child('uploads').child(fileName!);
          await storageRef.putFile(_image!);
           downloadUrl = await storageRef.getDownloadURL();
           setState(() {
             uploading = false;
           });

          print('File uploaded successfully: $downloadUrl');

        } catch (e) {
          print('Upload failed: $e');
          // You could also implement retry logic here if needed
        }
    }
  }


  Future<void> _uploadProduct() async {

    print('chceck data...-$_image..$_category');
    if (_formKey.currentState!.validate() && _image != null && _category != null) {
      try {

        String timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

        // Add product details to Firestore
        await FirebaseFirestore.instance.collection('products').doc(timestamp).set({
          'id': timestamp,
          'name': _nameController.text,
          'category': _category,
          'price': double.parse(_priceController.text),
          'imageUrl': downloadUrl??'',
          'quantity': 1,
        }, SetOptions(merge: true));

        // Show success message
        Get.snackbar('Success', 'Product added successfully!',backgroundColor: Colors.green);
        Navigator.pop(context);
        // Optionally navigate back
        // Get.back();
      } catch (e) {
        // Handle error
        Get.snackbar('Error', 'Failed to add product: $e');
      }
    } else {
      Get.snackbar('Error', 'Please fill in all fields and select an image',backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _category,
                onChanged: (value) {
                  print('value..$value');
                  setState(() {
                    _category = value;
                  });

                  print('value..${_category}');
                },
                decoration: const InputDecoration(labelText: 'Category'),
                items: categories.keys.map((category) => DropdownMenuItem(
                  value: categories[category],
                  child: Text(categories[category]!),
                )).toList(),
                //validator: (value) => value == null ? 'Please select a category' : null,
              ),

              // Name Text Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a product name' : null,
              ),

              // Price Text Field
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a price';
                  } else if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),

              // Image Upload Icon
              SizedBox(height: 16),
              // GestureDetector(
              //   onTap: _pickImage,
              //   child: CircleAvatar(
              //     radius: 50,
              //     backgroundColor: Colors.grey[300],
              //     child: _image == null
              //         ? Icon(Icons.add_a_photo, size: 40, color: Colors.grey[700])
              //         : ClipOval(child: Image.file(_image!, fit: BoxFit.cover, width: 100, height: 100)),
              //   ),
              // ),

              // Submit Button

              Container(
                padding: EdgeInsets.only(right: 8),
                width: (screenwidth > 640)
                    ? 630
                    : (screenwidth < 450)
                    ? screenwidth
                    : screenwidth,
                child: Column(
                  // co: WrapAlignment.end,
                  // alignment: WrapAlignment.end ,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // runSpacing: screenwidth > 450 ? 10 : 6,
                  // spacing: screenwidth > 450 ? 10 : 6,

                  children: [
                    InkWell(
                      onTap: () {
                        // Call SelectFile using a try-catch block to handle any exceptions
                        try {
                          _pickImage();
                        } catch (e) {
                          print("Error selecting file: $e");
                        }
                      },
                      child: Container(
                        height: 35,
                        width: screenwidth < 600 ? 50 : 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.3),
                              offset: Offset(3, 3),
                              blurRadius: 5,
                              spreadRadius: 0.01,
                            ),
                          ],
                        ),
                        child: Center(
                          child: uploading
                              ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(color: Colors.white)),
                          )
                              : const Icon(
                            Icons.attach_file,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                     if (
                    fileName.toString().toLowerCase().split('.').last==('jpg') ||
                        fileName.toString().toLowerCase().split('.').last==('jpeg') ||
                        fileName.toString().toLowerCase().split('.').last==('gif') ||
                        fileName.toString().toLowerCase().split('.').last==('png') ||
                        fileName.toString().toLowerCase().split('.').last==('heic') ||
                        fileName.toString().toLowerCase().split('.').last==('webp') ||
                        fileName.toString().toLowerCase().split('.').last==('svg') ||
                        fileName.toString().toLowerCase().split('.').last==('tif') ||
                        fileName.toString().toLowerCase().split('.').last==('tiff'))
                       downloadUrl != null
                     ?  Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 75,
                              child: Center(
                                child: Image.network(
                                  // _image!,
                                  downloadUrl??'',
                                  width: 75,
                                  fit: BoxFit.fitWidth,

                                ),
                              ),
                            ),
                          ),
                          cancelUploadImage(fileName.toString())
                        ],
                      ):Container()
                    else
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Text("No file chosen",
                          style: TextStyle(
                            fontSize:
                            screenwidth < 600 ? 12 : 14,
                          ),
                        ),
                      )
                  ],
                ),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    onPressed:(){
                      _uploadProduct();
                    },
                    child: Text('Add Product'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  cancelUploadImage(String imagePath) {
    return InkWell(
      onTap: (){
        setState(() {
          selectedFileNames.remove(imagePath);
          fileName = null;
          _image=null;
        });
        print('Image deleted successfully.');

      },
      child: Container(
        alignment: Alignment.center,
        width: 25,
        height: 25,
        decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle
          // borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.close,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }

}
