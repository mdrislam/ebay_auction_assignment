import 'dart:io';

import 'package:auction/components/customButton.dart';
import 'package:auction/const/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AuctionForm extends StatefulWidget {
  const AuctionForm({Key? key}) : super(key: key);

  @override
  _AuctionFormState createState() => _AuctionFormState();
}

class _AuctionFormState extends State<AuctionForm> {
  TextEditingController _auctionDateController = TextEditingController();
  TextEditingController _auctionTimeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String description = "";
  String minBidPrice = "";
  String auctionDate = "";
  String auctionTime = "";
  File? _imageFile;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColorsConst.deep_orrange,
          title: const Text(
            'Add Aution Product ',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        child: _imageFile != null
                            ? Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(_imageFile!),
                                  ),
                                ),
                              )
                            : Container(
                                height: 200,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: FlatButton(
                        color: AppColorsConst.deep_orrange.withOpacity(0.80),
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
                        child: const Text(
                          'Select',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        onPressed: () {
                          _getStoragePermission();
                          _showPicker(context);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Product Name ",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Requirdd *";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => setState(() => name = value),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Product Description ",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Requirdd *";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => setState(() => description = value),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Minimum Bid Price ",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Requirdd *";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => setState(() => minBidPrice = value),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _auctionDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                          labelText: "Select auction end date ",
                          border: const OutlineInputBorder(),
                          suffix: IconButton(
                            onPressed: () {
                              _selectDateFromPicker(context);
                            },
                            icon: const Icon(Icons.calendar_today_outlined),
                          )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Requirdd *";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => setState(() => auctionDate = value),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _auctionTimeController,
                      readOnly: true,
                      decoration: InputDecoration(
                          labelText: "Select auction end Time ",
                          border: const OutlineInputBorder(),
                          suffix: IconButton(
                            onPressed: () => _selectTimeFromPicker(context),
                            icon: const Icon(Icons.timer),
                          )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Requirdd *";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => setState(() => auctionTime = value),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: SizedBox(
                        height: 56.0,
                        width: 140.0,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_imageFile.toString().isEmpty) {
                              Fluttertoast.showToast(
                                  msg: " Select a Image File!",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.redAccent);
                            } else {
                              if (_formKey.currentState!.validate()) {
                                insertDataToDB();
                              }
                            }
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: AppColorsConst.deep_orrange,
                            elevation: 3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() async {
    final shouldPop = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Are you sure ?"),
              content: Text("Do you want to leave without saving?"),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("No"),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("Yes"),
                ),
              ],
            ));
    return shouldPop ?? false;
  }

  Future<bool> _getStoragePermission() async {
    bool permissionGranted = false;
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
      });
    }
    return permissionGranted;
  }

  //Show Image Picker Option Dialog
  Future _showPicker(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        pickedImage();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _getFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  //Pick Image From Gallery
  Future pickedImage() async {
    print("Cheak");
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  //Get from Camera
  Future _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  //Date Picker Dialog
  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 3));
    if (picked != null) {
      setState(() {
        _auctionDateController.text =
            "${picked.year}-${picked.month}-${picked.day} ";
      });
    }
  }

  //Time Picker Dialog
  Future<void> _selectTimeFromPicker(BuildContext context) async {
    final TimeOfDay initialTime = TimeOfDay.now();
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    String formattedTime = localizations.formatTimeOfDay(selectedTime!,
        alwaysUse24HourFormat: false);

    if (formattedTime != null) {
      setState(() {
        _auctionTimeController.text = "${formattedTime}";
      });
    }
  }

  //Save data to FireStore
  insertDataToDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var _currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("Auction_data");
    String tblId = _collectionRef.doc().id;

    await uploadImage(_imageFile!).then((value) => {
          _collectionRef
              .doc(tblId)
              .set({
                "tblId": tblId,
                "uId": _currentUser!.uid,
                "name": name,
                "description": description,
                "photo": value,
                "minBidPrice": minBidPrice,
                "date": _auctionDateController.text,
                "time": _auctionTimeController.text,
              })
              .then(
                (value) => Navigator.of(context).pop(),
              )
              .onError((error, stackTrace) =>
                  //Fluttertoast.showToast(msg: "Something was Wrong . $error")
                  print("Error: " + error.toString()))
        });
  }

  //Upload Imagem to FireBase Storage
  Future<String> uploadImage(File image) async {
    var url;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("image1" + DateTime.now().toString());
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }
}
