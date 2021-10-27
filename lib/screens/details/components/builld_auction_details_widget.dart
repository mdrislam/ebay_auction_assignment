import 'package:auction/const/app_colors.dart';
import 'package:auction/utills/utills_method.dart';
import 'package:flutter/material.dart';

class BuilldAuctionDetailsWidget extends StatelessWidget {
  BuilldAuctionDetailsWidget({
    Key? key,
    required this.auctionData,
  }) : super(key: key);

  var auctionData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
              child: auctionData['photo'] != null
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(auctionData['photo']),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(10.0)),
                    )
                  : Container(
                      width: 200,
                      height: 200,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ))),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          'Name: ${auctionData['name']}',
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          'Description: ${auctionData['description']}',
          maxLines: 40,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          'Min Bid Rate: ${auctionData['minBidPrice']}',
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          'End Date : ${UtillsMethod.getEndDate('${auctionData["date"] + auctionData["time"]}')}',
          maxLines: 2,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: AppColorsConst.deep_orrange),
        ),
        const SizedBox(
          height: 50.0,
        ),
      ],
    );
  }
}
