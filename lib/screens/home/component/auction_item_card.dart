import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AuctionItemCard extends StatelessWidget {
  AuctionItemCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  var product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Ink.image(
                  image: NetworkImage(product['photo']),
                  height: 250,
                  fit: BoxFit.cover,
                  child: InkWell(
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 100,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name: ${product['name'].toString()}",
                          maxLines: 1,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                        ),
                        Text(
                          "MinBid Price: ${product['minBidPrice'].toString()}",
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "End Date: " +
                              getEndDate(product["date"] + product["time"]),
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  String getEndDate(String date) {
    var returnString = '';
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd kk:mm a');
    final today = formatter.format(now);
    final fromDate = formatter.parse(date);
    final toDate = formatter.parse(today);

    var days = toDate.difference(fromDate).inDays;
    var hour = toDate.difference(fromDate).inHours % 24;
    var minute = toDate.difference(fromDate).inMinutes % 60;
    if (minute > 0) {
      if (days < 1) {
        returnString = "Days: ${0} Hour: ${hour} Minute: ${minute}";
      } else {
        returnString = "Days: ${days} Hour: ${hour} Minute: ${minute}";
      }
    } else {
      returnString = "Complete";
    }

    return returnString;
  }
}
