import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final int orderTotal;

  const PaymentScreen({Key? key, required this.orderTotal}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'Credit/Debit Card';

  void _onPaymentMethodChanged(String? method) {
    setState(() {
      _selectedPaymentMethod = method!;
    });
  }

  void _proceedToPayment() {
    // Logic for proceeding to payment goes here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Proceeding to Payment via $_selectedPaymentMethod')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ORDER TOTAL',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '₹${widget.orderTotal.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Payment Method Section
            Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            RadioListTile(
              title: const Text('Credit/Debit Card'),
              value: 'Credit/Debit Card',
              groupValue: _selectedPaymentMethod,
              onChanged: _onPaymentMethodChanged,
            ),
            RadioListTile(
              title: const Text('Cash on Delivery'),
              value: 'Cash on Delivery',
              groupValue: _selectedPaymentMethod,
              onChanged: _onPaymentMethodChanged,
            ),
            Spacer(),

            // Proceed to Payment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _proceedToPayment,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Proceed to Payment',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
