import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imageapi/service/apiservice.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final isImageSelected = false.obs;

  final ImagePicker _picker = ImagePicker();

  late XFile? image;
  final APIProvider myapi = APIProvider();

  void showLoadingDialog() {
    Get.defaultDialog(
        title: "",
        content: Material(
          child: Column(
            children: [
              const CircularProgressIndicator(),
              Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: const Text("Uploading Image")),
            ],
          ),
        ));
  }

  void showErrorDialog() {
    Get.defaultDialog(
        title: "Error",
        content: Material(
          child: Column(
            children: const [
              Text(
                "Image Uploading Failed",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        onCancel: () {
          Get.back();
        });
  }

  void showSuccessDialog() {
    Get.defaultDialog(
      title: "Success",
      content: Material(
        child: Column(
          children: const [
            Text(
              "Successfully uploaded image",
              style: TextStyle(color: Colors.green),
            ),
          ],
        ),
      ),
      cancel: ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("Back")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Uploader"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() => isImageSelected.value
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image(
                      image: FileImage(File(image!.path)),
                      height: 200,
                      width: 200,
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("No image seleced"),
                  )),
            ElevatedButton(
                onPressed: () async {
                  image = null;
                  isImageSelected.value = false;
                },
                child: const Text("Clear Image")),
            ElevatedButton(
                onPressed: () async {
                  image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image == null) {
                    isImageSelected.value = false;
                  } else {
                    isImageSelected.value = true;
                  }
                },
                child: const Text("Select a Image")),
            ElevatedButton(
                onPressed: () async {
                  if (isImageSelected.value) {
                    showLoadingDialog();
                    var isImageUploaded =
                        await myapi.postAImage(File(image!.path));
                    if (isImageUploaded) {
                      Get.back();
                      showSuccessDialog();
                    } else {
                      Get.back();
                      showErrorDialog();
                    }
                  } else {
                    Get.defaultDialog(
                        title: "Please select a image first",
                        content: const Text("No Files Selected Yet"));
                  }
                },
                child: const Text("Upload Image "))
          ],
        ),
      ),
    );
  }
}
