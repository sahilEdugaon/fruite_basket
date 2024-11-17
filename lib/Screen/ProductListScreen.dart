import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'AddProductScreen.dart';
import 'CartProduct/cart.dart';
import 'ProductController.dart';
import 'ProductDetails/productDetails.dart';

class ProductListScreen extends StatelessWidget {
   ProductListScreen({super.key});
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text("Product List"),
        backgroundColor: Colors.black,
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
      body:Obx((){

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.8,
            ),
            itemCount: productController.products.length, // Number of items (can be dynamic)
            itemBuilder: (context, index) {
              var data = productController.products[index];
              return InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProductDetailScreen(productId:data['id']);
                  },));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            data['imageUrl'],
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
                      ),

                      Text(
                        data['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('₹${data['price']} Kg',style: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.bold),)
                        ],
                      ),
                      SizedBox(height: 8),
                      Obx(() {
                        //productController.fetchCart();
                        //print('value..${productController.productCart.value.toSet().toList().contains(data['id'])}');
                        return productController.productCart.value.toSet().toList().contains(data['id'])
                            ?ElevatedButton(
                          onPressed: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingCartPage(),));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.yellow,
                          ),
                          child:  Text("Go to Cart",style: TextStyle(color: Colors.black)),
                        )
                            :ElevatedButton(
                          onPressed: () async {
                            // Add to cart action
                            await FirebaseFirestore.instance.collection('cart').doc(data['id'].toString()).set({
                              'product_id':data['id'],
                              'name':data['name'],
                              'category':data['category'],
                              'price':data['price'],
                              'imageUrl':data['imageUrl'],
                              'quantity':1,
                              'isActive':1
                            },SetOptions(merge: true));
                            // productController.fetchProducts();
                            // productController.fetchCart();
                            productController.products.refresh();
                            Get.snackbar('Success', 'Cart Added',backgroundColor: Colors.green,colorText: Colors.white);

                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                          ),
                          child:  Text("Add to cart"),
                        );
                      })
                      ,
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed:(){
          // Get.off(const AddProductScreen());
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen(),));
        },
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
    );
  }
}