import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CartController extends GetxController {
  var cartItems = [].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    fetchCart();
    super.onInit();
  }

  Future<void> incrementQuantity(int index) async {
    int currentQuantity = int.parse(cartItems[index]['quantity'].toString()); // Ensure it's an integer
    cartItems[index]['quantity'] = currentQuantity + 1;
    await FirebaseFirestore.instance.collection('cart').doc(cartItems[index]['product_id']).update({
      'quantity':cartItems[index]['quantity']
    });
    print('indextren..${cartItems[index]}');
    cartItems.refresh(); // Update UI

  }
  Future<void> decrementQuantity(int index) async {
    int currentQuantity = int.parse(cartItems[index]['quantity'].toString());
    if (currentQuantity > 1) {
      cartItems[index]['quantity'] = currentQuantity - 1;
      await FirebaseFirestore.instance.collection('cart').doc(cartItems[index]['product_id']).update({
        'quantity':cartItems[index]['quantity']
      });
      cartItems.refresh(); // Update UI
    }
  }
  void removeItem(String docId) {
    FirebaseFirestore.instance.collection('cart').doc(docId).update({
      'isActive':0
    });
  }
  // Fetch products from Firestore and update the products list
  void fetchCart() async {
    FirebaseFirestore.instance.collection('cart').where('isActive',isEqualTo: 1).snapshots().listen((value){
      // Directly map the Firestore data to the products list
      cartItems.value = value.docs.map((doc) {
        return {
          'product_id': doc.id,
          'name': doc['name'],
          'price': doc['price'],
          'category': doc['category'],
          'imageUrl': doc['imageUrl'],
          'quantity': doc['quantity'],
        };
      }).toList();
    });

  }

}