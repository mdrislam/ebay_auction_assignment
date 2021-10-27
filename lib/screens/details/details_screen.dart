import 'package:auction/const/app_colors.dart';
import 'package:auction/screens/details/components/builld_auction_details_widget.dart';
import 'package:auction/utills/utills_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/biding_list_items.dart';

class DetailsScreen extends StatefulWidget {
  var auctionData;

  DetailsScreen({Key? key, required this.auctionData}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  var path =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png';
  List auctionDataList = [];
  final _fireStoreInstanse = FirebaseFirestore.instance;

  fetchProductsData() async {
    QuerySnapshot qn = await _fireStoreInstanse
        .collection('Auction_data')
        .doc(widget.auctionData['tblId'])
        .collection("Biding_data").orderBy('price',descending: true)
        .get();

    setState(() {
      auctionDataList.clear();
      for (int i = 0; i < qn.docs.length; i++) {
        auctionDataList.add({
          "uId": qn.docs[i]['uId'],
          "name": qn.docs[i]['name'],
          "price": qn.docs[i]['price'],
          "quantity": qn.docs[i]['quantity'],
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchProductsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColorsConst.deep_orrange,
          title: const Text(
            ' Aution Details ',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  BuilldAuctionDetailsWidget(auctionData: widget.auctionData),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Biding List ',
                            maxLines: 2,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: AppColorsConst.deep_orrange),
                          ),
                          IconButton(
                              onPressed: () {
                                showImagePickerDialog(
                                  context,
                                );
                              },
                              icon: const Icon(
                                Icons.add,
                                size: 40,
                              ))
                        ],
                      ),
                    ),
                  ),
                  BidingListItems(
                    bidingdataList: auctionDataList,
                    tblId: widget.auctionData['tblId'],
                  ),
                ],
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
              content: Text("Do you want to leave without Biding?"),
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

  //Save Bid under product
  void insertBidNow(String tblId, String price, String quantity) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    var _currentUser = _auth.currentUser;
    print(tblId);

    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection('Auction_data')
        .doc(tblId)
        .collection("Biding_data");

    _collectionRef.doc(_auth.currentUser!.uid).set(
      {
        "uId": _currentUser!.uid,
        "name": _currentUser.displayName,
        "price": price,
        "quantity": quantity,
      },
    ).then((value) {
      fetchProductsData();
      Navigator.of(context).pop();
      UtillsMethod.showToast(Colors.green, 'Sucessfully Biding ');
    }).onError((error, stackTrace) {
      print("Error: " + error.toString());
    });
  }

  //Pick Image From Gallary
  Future<void> showImagePickerDialog(
    BuildContext context,
  ) async {
    final _formKey = GlobalKey<FormState>();
    String price = '';
    String quantity = '';
    return await showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Biding Dialog Box',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColorsConst.deep_orrange),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: " Bid Price ",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Requirdd *";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => setState(() => price = value),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Products Quantity ",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Requirdd *";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => setState(() => quantity = value),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      if (FirebaseAuth.instance.currentUser != null) {
                        if (_formKey.currentState!.validate()) {
                          insertBidNow(
                              widget.auctionData['tblId'], price, quantity);
                        }
                      } else {
                        UtillsMethod.showToast(
                            Colors.red, 'you are not registered user');
                      }
                    },
                    child: const Text("Save")),
                const SizedBox(
                  width: 30,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("cancel")),
              ],
            );
          });
        });
  }
}
