import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:untitled1/providers/Shop%20provider.dart';
class CartScreen extends StatelessWidget {
  static const String routeName = "CartScreen";

  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          Consumer<ShopProvider>(
            builder: (context, provider, child) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Badge(
                    label: Text(provider.cartCount.toString()),
                    isLabelVisible: provider.cartCount > 0,
                    child: const Icon(Icons.shopping_bag_outlined, color: Colors.blue),
                  ),
                ),
              );
            },
          )
        ],
      ),

      body: Consumer<ShopProvider>(
        builder: (context, provider, child) {
          if (provider.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_shopping_cart_outlined, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text('السلة فارغة حالياً', style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade800),
                    child: const Text('تسوق الآن', style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            );
          }
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, spreadRadius: 2)],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text("Items Total", style: TextStyle(color: Colors.grey, fontSize: 16)),
                        Text('${provider.totalPrice.toStringAsFixed(2)} \$',
                            style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                     SizedBox(height: 12),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Shipping Fee', style: TextStyle(color: Colors.grey, fontSize: 16)),
                        Text('Free', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                     Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(thickness: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('${provider.totalPrice.toStringAsFixed(2)} \$',
                            style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = provider.cartItems[index];
                    final product = cartItem.product;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(

                              width: 80,
                              height: 80,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: (product.image != null && product.image!.isNotEmpty)
                                  ? CachedNetworkImage(
                                imageUrl: product.image!,
                                fit: BoxFit.contain,
                                placeholder: (context, url) => Center(child: SizedBox(width: 20, height: 20,
                                  child:Image.asset("assets/images/image 50.png"),)),
                                errorWidget: (context, url, error) =>  Icon(Icons.broken_image,
                                    color: Colors.grey),
                              )
                                  :  Icon(Icons.image_not_supported, color: Colors.grey),
                            ),
                             SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title ?? 'بدون اسم',
                                    style:  TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                   SizedBox(height: 8),
                                  Text(
                                    '${product.price ?? 0.0} \$',
                                    style:  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () => provider.deleteFromCart(product),
                                  child:  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Icon(Icons.delete_outline, color: Colors.red, size: 24),
                                  ),
                                ),
                                 SizedBox(height: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () => provider.removeOneFromCart(product),
                                        child:  Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            child: Icon(Icons.remove, size: 16)),
                                      ),
                                      Text('${cartItem.quantity}', style:  TextStyle(fontWeight: FontWeight.bold,
                                          color: Colors.blue, fontSize: 14)),
                                      InkWell(
                                        onTap: () => provider.addToCart(product),
                                        child:  Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            child: Icon(Icons.add, size: 16, color: Colors.blue)),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5, offset: const Offset(0, -3))],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تأكيد الطلب بنجاح! '), backgroundColor: Colors.green),

                    );
                  },
                  child: const Text('Checkout', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}