import 'package:auction/screens/details/details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'auction_item_card.dart';

class AutionItems extends StatelessWidget {
  AutionItems({
    Key? key,
    required this.products,
  }) : super(key: key);

  final List products;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        itemCount: products.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) => AuctionItemCard(
          product: products[index],
          press: () {
            if (getEndDate(products[index]["date"] + products[index]["time"])
                    .toString() ==
                'Complete') {
              print('Bid Is Complete');
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
          },
        ),
      ),
    );
  }

  String getEndDate(String date) {
    var returnString = '';
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd kk:mm aa');
    final today = formatter.format(now);
    final fromDate = formatter.parse(date);
    final toDate = formatter.parse(today);

    var days = toDate.difference(fromDate).inDays;
    var hour = toDate.difference(fromDate).inHours % 24;
    var minute = toDate.difference(fromDate).inMinutes % 60;

    if (now.day == fromDate.day) {
      if (now.hour >= fromDate.hour && now.minute >= fromDate.minute) {
        print('Complete Over');
        returnString = 'Complete';
      } else {
        var run = " Hour: $hour Minute: $minute";
        print(run);
        returnString = run;
      }
    } else if (now.day > fromDate.day) {
      print('Complete Day is');
      returnString = 'Complete';
    } else {
      var str = "Days: $days Hour: $hour Minute: $minute";
      print('Running: $str');
      returnString = str;
    }

    return returnString;
  }
}
