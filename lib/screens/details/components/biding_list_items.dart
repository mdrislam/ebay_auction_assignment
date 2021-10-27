import 'package:flutter/material.dart';

import '../details_screen.dart';
import 'biding_items_card.dart';

class BidingListItems extends StatelessWidget {
  BidingListItems({Key? key, required this.bidingdataList,required this.tblId}) : super(key: key);
  List bidingdataList;
  var tblId;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        itemCount:bidingdataList.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) => BindingItmsCard(
          bidingData: bidingdataList[index],tblId: tblId,
        ),
      ),
    );
  }
}
