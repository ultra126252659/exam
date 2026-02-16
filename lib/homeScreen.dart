import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:untitled1/model/Items.dart';
import 'package:untitled1/providers/Shop%20provider.dart';

import 'cartScreen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "HomeScreen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShopProvider>().fetchProducts();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: Container(
          width: 86,
            height:41 ,
          margin:EdgeInsets.only(left: 16),
            child: Image.asset("assets/images/logo (4).png"),),

        actions: [
          Consumer<ShopProvider>(
            builder: (context, provider, child) {
              return Badge(
                label: Text(provider.cartCount.toString()),
                isLabelVisible: provider.cartCount > 0,
                child: IconButton(
                  icon:  Icon(Icons.shopping_bag_outlined, color: Colors.black87),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                  },
                ),
              );
            },
          ),
           SizedBox(width: 15),
        ],
      ),
      body: Consumer<ShopProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.error_outline, color: Colors.red, size: 60),
                   SizedBox(height: 10),
                  Text(provider.errorMessage!, style:  TextStyle(fontSize: 16)),
                   SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => provider.fetchProducts(),
                    child:  Text('إعادة المحاولة'),
                  )
                ],
              ),
            );
          }
          if (provider.products.isEmpty) {
            return  Center(child: Text("مفيش منتجات حالياً"));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: provider.products.length,
            itemBuilder: (context, index) {
              final product = provider.products[index];
              final quantityInCart = provider.getQuantityInCart(product.id);

              return Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(
                          child: (product.image != null && product.image!.isNotEmpty)
                              ? CachedNetworkImage(
                            imageUrl: product.image!,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Center(
                                child: SizedBox(
                                    child: Image.asset("assets/images/image 49.png"),
                                )
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                          )
                              : const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.title ?? '  مفيش اسم',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:  TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                       SizedBox(height: 4),
                      Row(
                        children: [
                           Icon(Icons.star, color: Colors.amber, size: 14),
                          Text(' ${product.rating?.rate ?? 0.0} (${product.rating?.count ?? 0})', style:  TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                       SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${product.price ?? 0.0} \$',
                              style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          quantityInCart > 0
                              ? Container(
                            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => provider.removeOneFromCart(product),
                                  child:  Padding(padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2), child: Icon(Icons.remove, size: 16, color: Colors.blue)),
                                ),
                                Text('$quantityInCart', style:  TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                                InkWell(
                                  onTap: () => provider.addToCart(product),
                                  child: const Padding(padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2), child: Icon(Icons.add, size: 16, color: Colors.blue)),
                                ),
                              ],
                            ),
                          )
                              : InkWell(
                            onTap: () => provider.addToCart(product),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                              child:  Icon(Icons.add_shopping_cart, color: Colors.blue, size: 18),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}