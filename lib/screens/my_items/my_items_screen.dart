import 'package:auction/const/app_colors.dart';
import 'package:auction/screens/details/details_screen.dart';
import 'package:auction/screens/home/component/auction_item_card.dart';
import 'package:auction/utills/utills_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyItemsScreen extends StatefulWidget {
  const MyItemsScreen({Key? key}) : super(key: key);

  @override
  _MyItemsScreenState createState() => _MyItemsScreenState();
}

class _MyItemsScreenState extends State<MyItemsScreen> {
  List products = [];
  final _fireStoreInstanse = FirebaseFirestore.instance;

  fetchProductsData() async {
    QuerySnapshot qn = await _fireStoreInstanse
        .collection("Auction_data")
        .where('uId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      products.clear();
      for (int i = 0; i < qn.docs.length; i++) {
        products.add({
          "tblId": qn.docs[i]['tblId'],
          "uId": qn.docs[i]['uId'],
          "name": qn.docs[i]['name'],
          "description": qn.docs[i]['description'],
          "photo": qn.docs[i]['photo'],
          "minBidPrice": qn.docs[i]['minBidPrice'],
          "date": qn.docs[i]['date'],
          "time": qn.docs[i]['time'],
        });
      }
    });
  }

  @override
  void initState() {
    fetchProductsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColorsConst.deep_orrange,
            title: const Text(
              ' My Posted Items ',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ListView.builder(
              itemCount: products.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),

              itemBuilder: (context, index) => AuctionItemCard(
                  product: products[index],
                  press: () {
                    if (UtillsMethod.getEndDate(products[index]["date"] +
                                products[index]["time"])
                            .toString() ==
                        'Complete') {
                      print('Bid Is Complete');
                      showWinnerDialog(context, products[index]["tblId"]);
                    } else {
                      print('Bid Is Running');
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) =>
                              DetailsScreen(auctionData: products[index]),
                        ),
                      ).then(
                        (value) {},
                      );
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() async {
    Navigator.of(context).pop(true);
    return true;
  }

  //Pick Image From Gallary
  Future<void> showWinnerDialog(
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
