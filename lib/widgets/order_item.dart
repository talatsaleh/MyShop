import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  ord.OrderItem orderData;

  OrderItem(this.orderData, {Key? key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.orderData.amount}'),
            subtitle: Text(DateFormat('dd MM yyyy hh:mm')
                .format(widget.orderData.dateTime)),
            trailing: IconButton(
              icon: expanded == true
                  ? const Icon(Icons.expand_less)
                  : const Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
            ),
          ),
          if (expanded == true)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.orderData.products.length * 20, 180),
              child: ListView(
                  children: widget.orderData.products
                      .map((prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                prod.title,
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text('\$${prod.price}',
                                  style: TextStyle(color: Colors.grey)),
                              Text('x ${prod.quantity}',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ))
                      .toList()),
            ),
        ],
      ),
    );
  }
}
