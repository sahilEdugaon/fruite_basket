import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_project_name/Screen/ProductController.dart';
import 'package:shimmer/shimmer.dart';

import '../ProductDetails/productDetails.dart';
import '../orderSummary/orderSummary.dart';
import 'cartController.dart';
class ShoppingCartPage extends StatelessWidget {
  final CartController controller = Get.put(CartController());
  final ProductController productController = Get.put(ProductController());

  ShoppingCartPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        actions: [
          Obx(() => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Icon(Icons.shopping_cart),
                if (controller.cartItems.isNotEmpty)
                  CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${controller.cartItems.length}',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
              ],
            ),
          )),
        ],
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return Center(child: Text('Your cart is empty'));
        }
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controller.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.cartItems[index];
                    print('iteem..$item');
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return ProductDetailScreen(productId:item['product_id']);
                        },));
                      },
                      child: Card(
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(child:
                              Image.network(
                                  item['imageUrl'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      color: Colors.grey,
                                      width: 60,
                                      height: 60,
                                    ),
                                  );
                                },
                              )
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    Text(
                                      'Kg ₹${(double.parse(item['price'].toString()) * int.parse(item['quantity'].toString())).toStringAsFixed(2)}',
                                      style: TextStyle(fontSize: 14, color: Colors.black),
                                    ),

                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, color: Colors.blue),
                                    onPressed: () => controller.decrementQuantity(index),
                                    color: Colors.green,
                                  ),
                                  Text('${item['quantity']}', style: TextStyle(fontSize: 16)),
                                  IconButton(
                                    icon: const Icon(Icons.add, color: Colors.blue),
                                    onPressed: () => controller.incrementQuantity(index),
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  controller.removeItem(item['product_id']);
                                  productController.productCart.remove(item['product_id']);
                                  productController.products.refresh();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Add to Cart and Buy Now buttons
              Visibility(
                visible: controller.cartItems.isNotEmpty,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Buy Now button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Buy now logic here
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>  OrderSummaryScreen(productList: controller.cartItems),));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: const Text(
                            'Buy Now',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
