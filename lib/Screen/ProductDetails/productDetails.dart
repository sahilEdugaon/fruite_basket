import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:intl/intl.dart';
import 'package:my_project_name/Screen/ProductDetails/details_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../CartProduct/cart.dart';
import '../ProductController.dart';
import '../orderSummary/orderSummary.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({
    required this.productId,
  });

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductDetailsController controller = Get.put(ProductDetailsController());
  DateTime currentDate = DateTime.now();
  final ProductController productController = Get.put(ProductController());

  @override
  void initState() {
    // TODO: implement initState
    controller.fetchProductDetails(widget.productId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    DateTime deliveryDate = currentDate.add(const Duration(days: 1));
// Format the date (e.g., "dd-MM-yyyy" format)
    String formattedDate = DateFormat('dd-MM-yyyy').format(deliveryDate);

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        // title:Text('${controller.productDetails['name']}') ,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // Navigate to cart or perform cart action
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingCartPage(),));
                },
              ),
              Obx(() {
                return  productController.cartLenght.value !=0
                    ?Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '${productController.cartLenght.value}', // Badge count
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      )
                  ),
                )
                    :Container();
              })

            ],
          ),
        ],
      ),
      body: Obx(() {
        return  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          /*    // Product Image
              Center(
                child: Image.network(
                  controller.productDetails['imageUrl'],
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.grey,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    );
                  },
                ),
              ),
*/
              Center(
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    scrollDirection: Axis.horizontal,
                    autoPlay: true, // Enables auto-scrolling
                    autoPlayInterval: Duration(seconds: 2), // Sets auto-scroll interval
                    autoPlayAnimationDuration: Duration(milliseconds: 800), // Smooth transition
                    autoPlayCurve: Curves.easeInOut, // Animation curve
                  ),
                  items: [controller.productDetails['imageUrl'].toString(),controller.productDetails['imageUrl'].toString(),controller.productDetails['imageUrl'].toString(),controller.productDetails['imageUrl'].toString(),].map<Widget>((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.grey,
                                width: double.infinity,
                                height: 200,
                              ),
                            );
                          },
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16),

              // Product Name and Rating
              Text('₹${controller.productDetails['price'].toString()} Kg',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Row(
                children: [
                  Icon(Icons.star, color: Colors.orange, size: 20),
                  Icon(Icons.star, color: Colors.orange, size: 20),
                  Icon(Icons.star, color: Colors.orange, size: 20),
                  Icon(Icons.star, color: Colors.orange, size: 20),
                  Icon(Icons.star_half, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Text('(4.5)', style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 8),
              Text(controller.productDetails['name'],style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17)),
              // Quantity Selector
              Row(
                children: [
                  Text(
                    'Kg ₹${(double.tryParse(controller.productDetails['price'].toString()) ?? 0) * (int.tryParse(controller.productDetails['quantity'].toString()) ?? 1)}',
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, color: Colors.black),
                          onPressed: () {
                            controller.decrementQuantity(controller.productDetails['id']);
                          },
                        ),
                        Text(
                          '${controller.productDetails['quantity']}',
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.black),
                          onPressed: () {
                            // controller.incrementQuantity(widget.productDetails['id']);
                           controller.incrementQuantity(controller.productDetails['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // delivey date
               Text(
                'Delivery Date $formattedDate',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              // Description
              Container(
                width:screenWidth ,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black)
                ),
                child: const Text(
                  'About Description',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),

              // Add to Cart and Buy Now buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    // Add to Cart button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Add to cart action
                          await FirebaseFirestore.instance.collection('cart').doc(controller.productDetails['id'].toString()).set({
                            'product_id':controller.productDetails['id'],
                            'name':controller.productDetails['name'],
                            'category':controller.productDetails['category'],
                            'price':controller.productDetails['price'],
                            'imageUrl':controller.productDetails['imageUrl'],
                            'quantity':controller.productDetails['quantity'],
                            'isActive':1
                          },SetOptions(merge: true));

                           productController.products.refresh();
                          Get.snackbar('Success', 'Cart Added',backgroundColor: Colors.green,colorText: Colors.white);
                          // Update Firestore
                          await FirebaseFirestore.instance.collection('products').doc(controller.productDetails['id']).update({
                            'quantity': 1,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),

                    // Space between buttons

                    // // Buy Now button
                    // Expanded(
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       // Buy now logic here
                    //       Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderSummaryScreen(),));
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.green,
                    //       padding: const EdgeInsets.symmetric(vertical: 16),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(5),
                    //       ),
                    //     ),
                    //     child: const Text(
                    //       'Buy Now',
                    //       style: TextStyle(fontSize: 18, color: Colors.white),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        );
      })

    );
  }
}
