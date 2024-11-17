import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductController extends GetxController {
  RxList products = [].obs;
  RxList productCart = [].obs;
  RxInt cartLenght = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchCart();
  }

  // Fetch products from Firestore and update the products list
  void fetchProducts() async {
    FirebaseFirestore.instance.collection('products').snapshots().listen((value){
      // Directly map the Firestore data to the products list
      products.value = value.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'price': doc['price'],
          'category': doc['category'],
          'imageUrl': doc['imageUrl'],
          'quantity': doc['quantity'],
        };
      }).toList();
    });

  }  // Fetch products from Firestore and update the products list
  void fetchCart() async {
    FirebaseFirestore.instance.collection('cart').where('isActive',isEqualTo: 1).snapshots().listen((value){
      cartLenght.value = value.docs.length;
      for(var item in value.docs){
        var docu= item.data();
        if(!productCart.value.contains(docu['product_id'])){
          productCart.value.add(docu['product_id']);
        }
      }
      // value.docs.map((doc) =>productCart.value.add(doc.id)).toSet().toList();
      print(productCart.value.toSet().toList());
      print('productController.cartLenght.value..${cartLenght.value}');
    });
    // Get.snackbar('Success', 'Cart Added',backgroundColor: Colors.green);

  }

}
