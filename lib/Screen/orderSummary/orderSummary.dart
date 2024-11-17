import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Payment/processt_to_pay.dart';

class OrderSummaryScreen extends StatefulWidget {
  final List productList;

  const OrderSummaryScreen({Key? key, required this.productList}) : super(key: key);

  @override
  _OrderSummaryScreenState createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {

  int totalAmount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTotal();
  }

  void getTotal(){
    for(var data in widget.productList){
      totalAmount += (double.parse(data['price'].toString()) * double.parse(data['quantity'].toString())).toInt();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.productList.length,
                itemBuilder:(context, index) {
                var data = widget.productList[index];

                  return  Column(
                    children: [
                        ProductItem(
                        imageUrl: data['imageUrl'],
                        title: data['name'],
                        quantity: data['quantity'],
                        price: data['price'].toString(),
                        totalPrice:(double.parse(data['price'].toString()) * int.parse(data['quantity'].toString())).toStringAsFixed(2),
                      ),
                     if(index != widget.productList.length-1)
                      const Divider(thickness: 1),
                    ],
                  );
                },
            ),
          ),

          // Order Summary Section
           Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ORDER SUMMARY',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
               SummaryRow(label: 'Subtotal:', value: '₹${totalAmount}') ,
                SummaryRow(label: 'Shipping:', value: '₹0.00'),
                SummaryRow(label: 'Tax:', value: '₹0.00'),
                Divider(thickness: 1),
                 SummaryRow(
                  label: 'Total:',
                  value: '₹${totalAmount}',
                  isBold: true,
                ),

              ],
            ),
          ),
          // Place Order Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Place order functionality
                Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(orderTotal: totalAmount,),));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: Size(double.infinity, 50), // Full-width button
              ),
              child: Text('Process To Pay'),
            ),
          ),
          SizedBox(height: 16),
          // Footer Section
          const Center(
            child: Column(
              children: [
                Text(
                  'PRIVACY   RETURN POLICY',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  'CUSTOMER SERVICE: 1.800.347.0288',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final int quantity;
  final String price;
  final String totalPrice;

  const ProductItem({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(width: 16),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                SizedBox(height: 8),
                Text('Qty: $quantity'),
                Text('Price: ₹$price'),
                Text('Total: ₹$totalPrice'),


              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const SummaryRow({
    Key? key,
    required this.label,
    required this.value,
    this.isBold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
