import 'package:auction/const/app_colors.dart';
import 'package:auction/screens/details/details_screen.dart';
import 'package:auction/utills/utills_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'auction_item_card.dart';

class AutionItems extends StatefulWidget {
  AutionItems({
    Key? key,
    required this.products,
  }) : super(key: key);

  final List products;

  @override
  State<AutionItems> createState() => _AutionItemsState();
}

class _AutionItemsState extends State<AutionItems> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        itemCount: widget.products.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) => AuctionItemCard(
          product: widget.products[index],
          press: () {
            if (UtillsMethod.getEndDate(widget.products[index]["date"] +
                        widget.products[index]["time"])
                    .toString() ==
                'Complete') {
              print('Bid Is Complete');
              showImagePickerDialog(context, widget.products[index]["tblId"]);
            } else {
              print('Bid Is Running');
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) =>
                      DetailsScreen(auctionData: widget.products[index]),
                ),
              ).then(
                (value) {},
              );
            }
          },
        ),
      ),
    );
  }

  //Pick Image From Gallary
  Future<void> showImagePickerDialog(
    BuildContext context,
    String tblId,
  ) async {
    List bidingDataList = [];
    bidingDataList.clear();
    final _fireStoreInstanse = FirebaseFirestore.instance;
    QuerySnapshot qn = await _fireStoreInstanse
        .collection('Auction_data')
        .doc(tblId)
        .collection("Biding_data")
        .orderBy('price', descending: true)
        .get();

    setState(() {
      bidingDataList.clear();
      for (int i = 0; i < qn.docs.length; i++) {
        bidingDataList.add({
          "uId": qn.docs[i]['uId'],
          "name": qn.docs[i]['name'],
          "price": qn.docs[i]['price'],
          "quantity": qn.docs[i]['quantity'],
        });
      }
    });

    return await showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Winner Dialog Box',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: AppColorsConst.deep_orrange),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        bidingDataList.isNotEmpty
                            ? Text(
                                'Name: ${bidingDataList[0]['name']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black),
                              )
                            : const Text(''),
                        const SizedBox(
                          height: 20.0,
                        ),
                        bidingDataList.isNotEmpty
                            ? Text(
                                'Price: ${bidingDataList[0]['price']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black),
                              )
                            : const Text(''),
                        const SizedBox(
                          height: 20.0,
                        ),
                        bidingDataList.isNotEmpty
                            ? Text(
                                'Quantity: ${bidingDataList[0]['quantity']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black),
                              )
                            : const Text(''),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "cancel",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    )),
              ],
            );
          });
        });
  }
}
