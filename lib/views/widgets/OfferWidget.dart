import 'package:ecotec/models/Offer.dart';
import 'package:flutter/material.dart';

class OfferWidget extends StatelessWidget {

  late Offer offer;
  VoidCallback? onTapItem;
  VoidCallback? onPressedRemover;

  OfferWidget({
    required this.offer,
    this.onTapItem,
    this.onPressedRemover
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTapItem,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(children: <Widget>[

            SizedBox(
              width: 120,
              height: 120,
              child: Image.network(
                offer.pictures[0],
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(offer.price),
                  ],
                ),
              )
            ),
            if(this.onPressedRemover != null) Expanded(
                flex: 1,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10))
                  ),
                  onPressed: this.onPressedRemover,
                  child: Icon(Icons.delete, color: Colors.white,),
                ),
            ),

          ],),
        ),
      ),
    );
  }
}
