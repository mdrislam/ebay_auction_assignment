import 'package:auction/const/app_colors.dart';
import 'package:auction/utills/utills_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'components/dashboard_menu_widget.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  List _products = [];
  final _fireStoreInstanse = FirebaseFirestore.instance;
  String totalValue ='';

  fetchProductsData() async {
    QuerySnapshot qn =
        await _fireStoreInstanse.collection("Auction_data").get();

    setState(() {
      _products.clear();
      for (int i = 0; i < qn.docs.length; i++) {
        _products.add({
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
    valueOfCompleteBidsString(_products);
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
            ' Dashboard ',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    child: Row(
                      children: [
                        DashBoard_Menu_Widget(
                            name: 'Running Bids',
                            data: totalRunningBids(_products).toString()),
                        const SizedBox(
                          width: 10.0,
                        ),
                        DashBoard_Menu_Widget(
                            name: 'Complete Bids',
                            data: totalCompleteBids(_products).toString()),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        DashBoard_Menu_Widget(
                            name: ' Value of Complete Bids',
                            data:
                                totalValue),
                      ],
                    ),
                  ),
                )
              ],
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

  String totalCompleteBids(List _productsList) {
    int counter = 0;
    for (int index = 0; index < _productsList.length; index++) {
      if (UtillsMethod.getEndDate(
                  _productsList[index]["date"] + _productsList[index]["time"])
              .toString() ==
          'Complete') {
        print('Bid Is Complete');
        counter++;
      }
    }
    return counter.toString();
  }

  String totalRunningBids(List _productsList) {
    int counter = 0;
    for (int index = 0; index < _productsList.length; index++) {
      if (UtillsMethod.getEndDate(
                  _productsList[index]["date"] + _productsList[index]["time"])
              .toString() ==
          'Complete') {
        print('Bid Is Complete');
      } else {
        counter++;
      }
    }
    return counter.toString();
  }

  //Set Total complete of value help with SetState
  valueOfCompleteBidsString(List _productsList) async {
    final String valueString = await totalValueOfCompleteBids(_productsList);
    print('Value of : $valueString');
    setState(() {
      totalValue = valueString;
    });

  }

  //Calculate  Total complete of value
  Future<String> totalValueOfCompleteBids(List _productsList) async {
    int counter = 0;

    for (int i = 0; i < _productsList.length; i++) {
      print(
          'Data: ${UtillsMethod.getEndDate(_productsList[i]["date"] + _productsList[i]["time"]).toString()}');
      if (UtillsMethod.getEndDate(
                  _productsList[i]["date"] + _productsList[i]["time"])
              .toString() ==
          'Complete') {
        final _fireStoreInstanse = FirebaseFirestore.instance;
        QuerySnapshot qn = await _fireStoreInstanse
            .collection('Auction_data')
            .doc(_productsList[i]["tblId"])
            .collection("Biding_data")
            .orderBy('price', descending: true)
            .get();

        if (qn.docs.isNotEmpty) {
          int price = int.parse(qn.docs[0]['price']);
          int quantity = int.parse(qn.docs[0]['quantity']);
          int multiply = price * quantity;
          counter = counter + multiply;
        } else {
          print('Docs is Empty');
        }
      }
    }
    print('Counter: $counter');
    return counter.toString();
  }
}
