import 'package:auction/const/app_colors.dart';
import 'package:auction/screens/aucton/auction_form.dart';
import 'package:auction/screens/home/component/menu_button_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'component/auction_item_card.dart';
import 'component/auction_items.dart';
import 'component/home_top_menu_items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  List _products = [];
  final _fireStoreInstanse = FirebaseFirestore.instance;

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
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    print('init State');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      setState(() {
        fetchProductsData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'eBay Auction',
            style: TextStyle(
                color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: AppColorsConst.deep_orrange,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HomeTopMenuItems(),
              AutionItems(products: _products),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColorsConst.deep_orrange,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => const AuctionForm(),
              ),
            ).then(
              (value) {
                setState(
                  () {
                    fetchProductsData();
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
