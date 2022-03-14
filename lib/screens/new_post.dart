import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';


class NewPost extends StatefulWidget {
  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final picker = ImagePicker();
  File? image; // make it nullable
  String? url;
  // String? url = "https://firebasestorage.googleapis.com/v0/b/wasteagram-82f7f.appspot.com/o/2022-03-13%2015:30:03.251169.jpg?alt=media&token=dbd90477-237f-4960-ac19-b013b744e7b1";
  var numOfEntities;
  final formKey = GlobalKey<FormState>(); // for forms

  @override
  void initState() {
    super.initState();
    retrieveImage(); //later called by setState
  }

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      // where there is no entry, show the default Scafoold view
      return Scaffold(
        appBar: AppBar(title: Text("Enter a new entry"), centerTitle: true),
        body: Center(child: CircularProgressIndicator())
      ); 
    } else {
      return  Scaffold (
        appBar: AppBar(title: Text("Enter a new entry"), centerTitle: true),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Semantics(
                  label: 'Picture of the wasted food.', 
                  child: Image.network('${url}')
                ),
                //Spacer(),
                Semantics(
                  label: 'Number of entries.', 
                  child: Form(
                    key: formKey,
                    child: 
                      TextFormField (
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        initialValue: 'Number of items',
                        keyboardType: TextInputType.numberWithOptions(decimal: false),
                        style: TextStyle(fontSize: 25),
                        textAlign: TextAlign.center,
                        validator: (enteredNumber) {
                          var intEnteredNumber = num.tryParse(enteredNumber as String);
                          if (intEnteredNumber == null){
                            return 'Please enter amount';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (enteredNumber) {numOfEntities = num.tryParse(enteredNumber as String);}
                      )
                  ),
                ),
                //Spacer(),
                Semantics(
                  button: true,
                  enabled: true,
                  onTapHint:  'Upload entry into Firebase cloud storage',
                  label: 'Upload entry',
                  child: GestureDetector(
                    onTap: uploadEntryToFirebase,
                    child: Icon(Icons.upload_file_outlined, size: 80),
                  ),
                )
              ],

            )

          ],
        )
        );
    }
  }

  Future retrieveImage() async {
    var pickerImage = await picker.pickImage(source: ImageSource.gallery);
    image = File(pickerImage!.path);
    Reference storageReference = FirebaseStorage.instance.ref().child(DateTime.now().toString() + '.jpg');
    UploadTask uploadTask = storageReference.putFile(image!);

    await uploadTask;
    this.url = await storageReference.getDownloadURL();
    print("Image stored at ${url}");
    setState(() {});
  }

  Future<LocationData> getLocation(Location location, LocationData? locationData) async {
    try {
      var serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        // if not enabled with locaiton service, ask again
        serviceEnabled = await location.requestService();
        // if still not enabled, print failure information, return a default location
        if (!serviceEnabled) {
          print("Location service not enabled.");
          // return default location
          Location defaultLocation = Location();
          return await defaultLocation.getLocation();
        }
      }

      var hasPermission = await location.hasPermission();
      if (hasPermission == PermissionStatus.denied) {
        // ask one more time, if still denined, then quit
        hasPermission = await location.requestPermission();
        if (hasPermission == PermissionStatus.granted) {
          print('Location service permitted');
        }
      }
      locationData = await location.getLocation();

    } on PlatformException catch (error) {
      print('Error getting location ${error.toString()}');
      // set locaiton to null
      locationData = null;
    }
    locationData = await location.getLocation();
    return locationData;
  }

  void uploadEntryToFirebase() async {
    if (formKey.currentState!.validate()) {
      // save the form
      formKey.currentState!.save();
      LocationData? locationData;
      var location = Location();
      locationData = await getLocation(location, locationData);

      FirebaseFirestore.instance.collection('posts')
      .add({
        'date': DateFormat('yyyy-MM-dd EEEE').format(DateTime.now()).toString(),
        'imageUrl': url,
        'numOfEntities': numOfEntities,
        'latitude': '${locationData.latitude}',
        'longitude': '${locationData.longitude}'
      });

      // remeber to pop out en element
      Navigator.of(context).pop();
    }
  }
}

