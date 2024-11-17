import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailsController extends GetxController {
  RxMap productDetails = {}.obs;

  @override
  void onInit() {
    super.onInit();
  }

  // Initialize product details with Firestore data for a specific product
  void fetchProductDetails(String productId) {
    FirebaseFirestore.instance.collection('products').doc(productId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        productDetails.assignAll(snapshot.data()!);
      }
    });
  }

  // Method to increment quantity and update Firestore
  Future<void> incrementQuantity(String productId) async {
    int currentQuantity = productDetails['quantity'] ?? 0;
    int newQuantity = currentQuantity + 1;

    // Update the local reactive map
    productDetails['quantity'] = newQuantity;

    // Update Firestore
    await FirebaseFirestore.instance.collection('products').doc(productId).update({
      'quantity': newQuantity,
    });
  }

  Future<void> decrementQuantity(String productId) async {
    int currentQuantity = productDetails['quantity'] ?? 0;
    if (currentQuantity > 1) {
      productDetails['quantity']  = currentQuantity - 1;
      await FirebaseFirestore.instance.collection('products').doc(productId).update({
        'quantity':productDetails['quantity']
      });
    }
  }

}
