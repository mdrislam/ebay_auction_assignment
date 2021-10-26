import 'package:flutter/material.dart';

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
        itemBuilder: (context, index) =>
            AuctionItemCard(product: products[index]),
      ),
    );
  }
}
