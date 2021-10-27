import 'package:auction/const/app_colors.dart';
import 'package:auction/utills/utills_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BindingItmsCard extends StatefulWidget {
  BindingItmsCard({Key? key, required this.bidingData, required this.tblId})
      : super(key: key);
  var bidingData;
  var tblId;

  @override
  State<BindingItmsCard> createState() => _BindingItmsCardState();
}

class _BindingItmsCardState extends State<BindingItmsCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Usd ${widget.bidingData['price']} ',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text(
                ' X ',
                style: TextStyle(
                    color: Colors.deepOrange, fontWeight: FontWeight.bold),
              ),
              Text(
                'Q ${widget.bidingData['quantity']}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          subtitle: Text(
            '${widget.bidingData['name']}',
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
          leading: const CircleAvatar(
            child: Icon(Icons.monetization_on),
          ),
          trailing: FirebaseAuth.instance.currentUser!.uid.toString() ==
                  widget.bidingData['uId'].toString()
              ? GestureDetector(onTap: () {
                showImagePickerDialog(context,widget.bidingData['price'],widget.bidingData['quantity']);
          }, child: const Text('Edit'))
              : const Text(''),
        ),
        Container(
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }

  //Save Bid under product
  void insertBidNow(
      BuildContext context, String tblId, String price, String quantity) {
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
      setState(() {});
      Navigator.of(context).pop();
      UtillsMethod.showToast(Colors.green, 'Sucessfully Updated ');

    }).onError((error, stackTrace) {
      print("Error: " + error.toString());
    });
  }

  //Pick Image From Gallary
  Future<void> showImagePickerDialog(
    BuildContext context,
      String uprice,String uquantity
  ) async {
    TextEditingController price = TextEditingController();
    TextEditingController quantity = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    setState(() {
      price.text =uprice;
      quantity.text =uquantity;
    });

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
                      'Update Dialog Box',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColorsConst.deep_orrange),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller:price ,
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

                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: quantity,
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

                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      if (FirebaseAuth.instance.currentUser != null) {
                        if (_formKey.currentState!.validate()) {
                          insertBidNow(context, widget.tblId, price.text, quantity.text);
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
